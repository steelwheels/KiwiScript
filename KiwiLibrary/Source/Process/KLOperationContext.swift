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
	func isFinished()  -> JSValue
	func isCancelled() -> JSValue

	func get(_ name: JSValue) -> JSValue
	func set(_ name: JSValue, _ val: JSValue)
	func setConsole(_ cons: JSValue)

	func executionCount() -> JSValue
	func totalExecutionTime() -> JSValue
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

	public func executionCount() -> JSValue {
		return JSValue(int32: Int32(super.executionCount), in: mOwnerContext)
	}

	public func totalExecutionTime() -> JSValue {
		return JSValue(double: super.totalExecutionTime, in: mOwnerContext)
	}

	public func isFinished() -> JSValue {
		let value = super.isFinished
		return JSValue(bool: value, in: mOwnerContext)
	}

	public func isCancelled() -> JSValue {
		let value = super.isCancelled
		return JSValue(bool: value, in: mOwnerContext)
	}

	open override func setParameter(name nm: String, value val: CNNativeValue){
		if let op = mOperationInstance, let setfunc = mSetFunction {
			if let nameval = JSValue(object: nm, in: mSelfContext) {
				let valobj  = val.toJSValue(context: mSelfContext)
				setfunc.call(withArguments: [op, nameval, valobj])
				return
			}
		}
		log(type: .Error, string: "Failed to exec _set_operation method", file: #file, line: #line, function: #function)
	}

	open override func parameter(name nm: String) -> CNNativeValue? {
		if let op = mOperationInstance, let getfunc = mGetFunction {
			if let nameval = JSValue(object: nm, in: mSelfContext) {
				if let retval = getfunc.call(withArguments: [op, nameval]) {
					return retval.toNativeValue()
				}
			}
		}
		log(type: .Error, string: "Failed to exec _get_operation method", file: #file, line: #line, function: #function)
		return nil
	}

	public func set(_ name: JSValue, _ val: JSValue){
		if name.isString {
			if let nstr = name.toString() {
				let nval = val.toNativeValue()
				self.setParameter(name: nstr, value: nval)
				return
			}
		}
		log(type: .Error, string: "Failed to set parameter", file: #file, line: #line, function: #function)
	}

	public func get(_ name: JSValue) -> JSValue {
		if name.isString {
			if let nstr = name.toString() {
				if let val = self.parameter(name: nstr) {
					return val.toJSValue(context: mOwnerContext)
				}
			}
		}
		return JSValue(nullIn: mOwnerContext)
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

	public func compile(userStructs structs: Array<CNNativeStruct>, userScripts scripts: Array<URL>) -> Bool {
		guard let cons = console else {
			NSLog("No console")
			return false
		}

		let compiler = KLOperationCompiler()
		let result: Bool
		if compiler.compile(context: mSelfContext, operation: self, userStructs: structs, userScripts: scripts, console: cons, config: mConfig) {
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
			return false
		}
		if let setfunc = ctxt.getValue(name: "_set_operation") {
			mSetFunction = setfunc
		} else {
			cons.error(string: "The built-in function \"_set_operation\" is NOT found\n")
			return false
		}
		if let execfunc = ctxt.getValue(name: "_exec_operation") {
			mExecFunction = execfunc
		} else {
			cons.error(string: "The built-in function \"_exec_operation\" is NOT found\n")
			return false
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
	public func compile(context ctxt: KEContext, operation op: KLOperationContext, userStructs structs: Array<CNNativeStruct>, userScripts scripts:  Array<URL>, console cons: CNConsole, config conf: KEConfig) -> Bool {
		if super.compile(context: ctxt, console: cons, config: conf) {
			compileOperationClass(context: ctxt, operation: op, console: cons, config: conf)

			/* Compile user defined library */
			for script in KLOperationContext.libraryScripts {
				let _ = super.compile(context: ctxt, statement: script, console: cons, config: conf)
			}

			let res0 = compileUserStructs(context: ctxt, userStructs: structs, console: cons, config: conf)
			let res1 = compileUserScripts(context: ctxt, userScripts: scripts, console: cons, config: conf)
			defineBuiltinFunction(context: ctxt, operation: op)
			return res0 && res1 && (ctxt.errorCount == 0)
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

	private func compileUserStructs(context ctxt: KEContext, userStructs structs: Array<CNNativeStruct>, console cons: CNConsole, config conf: KEConfig) -> Bool {
		/* Compile structs */
		for strct in structs {
			let _ = compile(context: ctxt, statement: strct.JSClassDefinition(), console: cons, config: conf)
		}
		return (ctxt.errorCount == 0)
	}

	private func compileUserScripts(context ctxt: KEContext, userScripts scripts: Array<URL>, console cons: CNConsole, config conf: KEConfig) -> Bool {
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

