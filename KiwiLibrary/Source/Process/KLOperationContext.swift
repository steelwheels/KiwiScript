/**
 * @file	KLOperationContext.swift
 * @brief	Define KLOperationContext class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

@objc public protocol KLOperationContextProtocol: JSExport
{
	func setParameter(_ name: JSValue, _ value: JSValue)
	func parameter(_ name: JSValue) -> JSValue

	func isCancelled() -> JSValue

	func setConsole(_ cons: JSValue)
}

@objc open class KLOperationContext: CNOperationContext, KLOperationContextProtocol
{
	/*
	 * Static library
	 */
	public static var mLibraryScripts: Array<String> 	= []

	public static var libraryScripts: Array<String> {
		get { return mLibraryScripts }
	}

	public static func addLibraryScript(script scr: String) {
		mLibraryScripts.append(scr)
	}

	/*
	 * Class body
	 */
	private var 	mOwnerContext:		KEContext
	private var	mSelfContext:		KEContext
	private var	mConfig:		KEConfig
	private var	mOperationInstance:	JSValue?
	private var	mGetFunction:		JSValue?
	private var	mSetFunction:		JSValue?
	private var 	mExecFunction:		JSValue?

	public init(ownerContext octxt: KEContext, console cons: CNConsole, config conf: KEConfig){
		mOwnerContext		= octxt
		mSelfContext		= KEContext(virtualMachine: JSVirtualMachine())
		mConfig			= conf
		mOperationInstance	= nil
		mGetFunction		= nil
		mSetFunction		= nil
		mExecFunction		= nil
		super.init(console: cons)

		setExceptionHandler()
	}

	private func setExceptionHandler(){
		mSelfContext.exceptionCallback = {
			[weak self] (_ exception: KEException) -> Void in
			if let myself = self {
				if let cons = myself.console {
					cons.error(string: exception.description + "\n")
					return
				}
			}
			NSLog("Internal error")
		}
	}

	public func isCancelled() -> JSValue {
		let value = super.isCancelled
		return JSValue(bool: value, in: mOwnerContext)
	}

	public func setParameter(_ nameval: JSValue, _ value: JSValue) {
		if let op = mOperationInstance, let setfunc = mSetFunction {
			let duplicator = KLValueDuplicator(targetContext: mSelfContext)
			let dupname = duplicator.duplicate(value: nameval)
			let dupval  = duplicator.duplicate(value: value)
			setfunc.call(withArguments: [op, dupname, dupval])
		} else {
			log(type: .Error, string: "No _set_operation method", file: #file, line: #line, function: #function)
		}
	}

	public func parameter(_ nameval: JSValue) -> JSValue {
		if let op = mOperationInstance, let getfunc = mGetFunction {
			let duplicator = KLValueDuplicator(targetContext: mSelfContext)
			let dupname    = duplicator.duplicate(value: nameval)
			if let retval = getfunc.call(withArguments: [op, dupname]) {
				let revduplicator = KLValueDuplicator(targetContext: mOwnerContext)
				return revduplicator.duplicate(value: retval)
			} else {
				log(type: .Error, string: "No result value", file: #file, line: #line, function: #function)
			}
		} else {
			log(type: .Error, string: "No _get_operation method", file: #file, line: #line, function: #function)
		}
		return JSValue(undefinedIn: mOwnerContext)
	}
	
	public func setConsole(_ newcons: JSValue){
		if let newobj = newcons.toObject() as? KLConsole {
			if let newval = JSValue(object: newobj, in: mSelfContext){
				mSelfContext.set(name: "console", value: newval)
				super.console = newobj.console
				return
			}
		}
		log(type: .Error, string: "Failed to set console", file: #file, line: #line, function: #function)
	}

	public func compile(userScripts scripts: Array<URL>) -> Bool {
		guard let cons = console else {
			NSLog("No console")
			return false
		}

		let compiler = KLOperationCompiler()
		let result: Bool
		if compiler.compile(context: mSelfContext, operation: self, userScripts: scripts, console: cons, config: mConfig) {
			result = getGlobalVariables(context: mSelfContext)
		} else {
			result = false
		}
		return result
	}

	private func getGlobalVariables(context ctxt: KEContext) -> Bool {
		guard let cons = console else {
			NSLog("No console")
			return false
		}
		if let opinstance = ctxt.getValue(name: "operation") {
			mOperationInstance = opinstance
		} else {
			cons.error(string: "The \"operation\" global variable must be defined.\n")
			return false
		}
		if let getfunc = ctxt.getValue(name: "_get_operation") {
			mGetFunction = getfunc
		} else {
			cons.error(string: "The built-in function \"_set_operation\" is NOT found\n")
		}
		if let setfunc = ctxt.getValue(name: "_set_operation") {
			mSetFunction = setfunc
		} else {
			cons.error(string: "The built-in function \"_set_operation\" is NOT found\n")
		}
		if let execfunc = ctxt.getValue(name: "_exec_operation") {
			mExecFunction = execfunc
		} else {
			cons.error(string: "The built-in function \"_exec_operation\" is NOT found\n")
		}
		return true
	}

	open override func main() {
		if let execfunc = mExecFunction, let op = mOperationInstance {
			/* Execute main method in Operation class */
			execfunc.call(withArguments: [op])
		}
	}
}

private class KLOperationCompiler: KLCompiler
{
	public func compile(context ctxt: KEContext, operation op: KLOperationContext, userScripts scripts:  Array<URL>, console cons: CNConsole, config conf: KEConfig) -> Bool {
		if super.compile(context: ctxt, console: cons, config: conf) {
			compileOperationClass(context: ctxt, operation: op, console: cons, config: conf)
			let res0 = compileUserScripts(context: ctxt, userScripts: scripts, console: cons, config: conf)
			defineBuiltinFunction(context: ctxt, operation: op)
			return res0 && (ctxt.errorCount == 0)
		} else {
			return false
		}
	}

	private func compileOperationClass(context ctxt: KEContext, operation op: KLOperationContext, console cons: CNConsole, config conf: KEConfig) {
		/* Compile "Operation.js" */
		if let script = readResource(fileName: "Operation", fileExtension: "js", forClass: KLOperationCompiler.self) {
			let _ = compile(context: ctxt, statement: script, console: cons, config: conf)
		} else {
			cons.error(string: "Failed to read Operation.js\n")
		}
	}

	private func compileUserScripts(context ctxt: KEContext, userScripts scripts: Array<URL>, console cons: CNConsole, config conf: KEConfig) -> Bool {
		/* Compile user defined library */
		for script in KLOperationContext.libraryScripts {
			let _ = super.compile(context: ctxt, statement: script, console: cons, config: conf)
		}

		/* Compile program */
		let scripts = URLsToScripts(URLs: scripts, console: cons)
		if scripts.count > 0 {
			for script in scripts {
				let _ = super.compile(context: ctxt, statement: script, console: cons, config: conf)
			}
		} else {
			cons.error(string: "Failed to compile: No user script\n")
		}

		return (ctxt.errorCount == 0)
	}

	private func URLsToScripts(URLs urls: Array<URL>, console cons: CNConsole) -> Array<String> {
		var scripts: Array<String> = []
		for url in urls {
			let (scriptp,errorp) = url.loadContents()
			if let err = errorp {
				cons.error(string: "[Error] \(err.description)\n")
			} else if let script = scriptp {
				/* Load suceeded */
				scripts.append(script as String)
			} else {
				fatalError("Can not reach here")
			}
		}
		return scripts
	}

	private func defineBuiltinFunction(context ctxt: KEContext, operation op: KLOperationContext) {
		/* Define exit function */
		let exitFunc = {
			(_ value: JSValue) -> JSValue in
			op.cancel()
			return JSValue(undefinedIn: ctxt)
		}
		ctxt.set(name: "exit", function: exitFunc)
	}
}

