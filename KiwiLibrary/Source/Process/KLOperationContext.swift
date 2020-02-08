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
	 * Class body
	 */
	private var 	mOwnerContext:		KEContext
	private var	mSelfContext:		KEContext
	private var	mLibraries:		Array<URL>
	private var	mConfig:		KEConfig
	private var	mOperationInstance:	JSValue?
	private var	mGetFunction:		JSValue?
	private var	mSetFunction:		JSValue?
	private var 	mExecFunction:		JSValue?

	public init(ownerContext octxt: KEContext, libraries libs: Array<URL>, input inhdl: FileHandle, output outhdl: FileHandle, error errhdl: FileHandle, config conf: KEConfig){
		mOwnerContext		= octxt
		mSelfContext		= KEContext(virtualMachine: JSVirtualMachine())
		mLibraries		= libs
		mConfig			= KEConfig(applicationType: conf.applicationType, doStrict: conf.doStrict, logLevel: conf.logLevel)
		mOperationInstance	= nil
		mGetFunction		= nil
		mSetFunction		= nil
		mExecFunction		= nil
		super.init(input: inhdl, output: outhdl, error: errhdl)

		setExceptionHandler()
	}

	private func setExceptionHandler(){
		mSelfContext.exceptionCallback = {
			[weak self] (_ exception: KEException) -> Void in
			if let myself = self {
				myself.console.error(string: exception.description + "\n")
				return
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
		self.console.error(string: "Failed to exec _set_operation method")
	}

	open override func parameter(name nm: String) -> CNNativeValue? {
		if let op = mOperationInstance, let getfunc = mGetFunction {
			if let nameval = JSValue(object: nm, in: mSelfContext) {
				if let retval = getfunc.call(withArguments: [op, nameval]) {
					return retval.toNativeValue()
				}
			}
		}
		self.console.error(string: "Failed to exec _get_operation method")
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
		self.console.error(string: "Failed to exec _set_parameter")
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
				set(console: newobj.console)
				return
			}
		}
		self.console.error(string: "Failed to set console")
	}

	public func compile(userStructs structs: Array<CNNativeStruct>, userScripts scripts: Array<URL>) -> Bool {
		let compiler = KLOperationCompiler()
		let result: Bool
		if compiler.compile(context: mSelfContext, operation: self, userStructs: structs, libraries: mLibraries, userScripts: scripts, console: self.console, config: mConfig) {
			result = getGlobalVariables(context: mSelfContext)
		} else {
			result = false
		}
		return result
	}

	private func getGlobalVariables(context ctxt: KEContext) -> Bool {
		if let opinstance = ctxt.getValue(name: "operation") {
			mOperationInstance = opinstance
		} else {
			self.console.error(string: "The \"operation\" global variable must be defined.\n")
			return false
		}
		if let getfunc = ctxt.getValue(name: "_get_operation") {
			mGetFunction = getfunc
		} else {
			self.console.error(string: "The built-in function \"_set_operation\" is NOT found\n")
			return false
		}
		if let setfunc = ctxt.getValue(name: "_set_operation") {
			mSetFunction = setfunc
		} else {
			self.console.error(string: "The built-in function \"_set_operation\" is NOT found\n")
			return false
		}
		if let execfunc = ctxt.getValue(name: "_exec_operation") {
			mExecFunction = execfunc
		} else {
			self.console.error(string: "The built-in function \"_exec_operation\" is NOT found\n")
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
	public func compile(context ctxt: KEContext, operation op: KLOperationContext, userStructs structs: Array<CNNativeStruct>, libraries libs: Array<URL>, userScripts scripts:  Array<URL>, console cons: CNFileConsole, config conf: KEConfig) -> Bool {
		if super.compileBase(context: ctxt, console: cons, config: conf) {
			compileOperationClass(context: ctxt, operation: op, console: cons, config: conf)

			var bothscripts = libs
			bothscripts.append(contentsOf: scripts)

			let res0 = compileUserStructs(context: ctxt, userStructs: structs, console: cons, config: conf)
			let res1 = compileUserScripts(context: ctxt, userScripts: bothscripts, console: cons, config: conf)
			defineBuiltinFunction(context: ctxt, operation: op)
			return res0 && res1 && (ctxt.errorCount == 0)
		} else {
			return false
		}
	}

	private func compileOperationClass(context ctxt: KEContext, operation op: KLOperationContext, console cons: CNConsole, config conf: KEConfig) {
		/* Compile "Operation.js" */
		do {
			if let url = CNFilePath.URLForResourceFile(fileName: "Operation", fileExtension: "js", forClass: KLOperationCompiler.self) {
				let script = try String(contentsOf: url, encoding: .utf8)
				let _ = compile(context: ctxt, statement: script, console: cons, config: conf)
			} else {
				NSLog("Failed to read Operation.js")
			}
		} catch {
			NSLog("Failed to read Operation.js")
		}
	}

	private func compileUserStructs(context ctxt: KEContext, userStructs structs: Array<CNNativeStruct>, console cons: CNConsole, config conf: KEConfig) -> Bool {
		/* Compile structs */
		for strct in structs {
			let _ = compile(context: ctxt, statement: strct.JSClassDefinition(), console: cons, config: conf)
		}
		return (ctxt.errorCount == 0)
	}

	private func compileUserScripts(context ctxt: KEContext, userScripts urls: Array<URL>, console cons: CNConsole, config conf: KEConfig) -> Bool {
		/* Compile program */
		let scripts = URLsToScripts(URLs: urls, console: cons)
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
			if let script = url.loadContents() {
				/* Load suceeded */
				scripts.append(script as String)
			} else {
				cons.error(string: "Failed to load contents from \(url.absoluteString)\n")
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

