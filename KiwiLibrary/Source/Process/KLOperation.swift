/**
 * @file	KLOperation.swift
 * @brief	Define KLOperation class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

@objc public protocol KLOperationProtocol: JSExport
{
	var isExecuting:	Bool { get }		// -> Bool
	var isFinished:		Bool { get }		// -> Bool
	var isCancelled:	Bool { get }		// -> Bool

	func compile(_ program: JSValue) -> JSValue

	func set(_ cmdid: JSValue, _ param: Any)
	func get(_ cmdid: JSValue) -> JSValue
}

@objc public class KLOperation: NSObject, KLOperationProtocol
{
	public static var mLibraryScripts: Array<String> 	= []

	private var 	mOperation:		CNOperation?
	private var	mOwnerContext:		KEContext
	fileprivate var	mSelfContext:		KEContext
	private var	mConsole:		CNConsole
	private var	mConfig:		KEConfig
	private var	mPropertyTable:		KEObject

	private var 	mOperationObject:	JSValue?
	private var	mSetFunction:		JSValue?
	private var	mGetFunction:		JSValue?
	private var	mExecFunction:		JSValue?


	public var propertyTable: KEObject	{ get { return mPropertyTable }}

	public static var libraryScripts: Array<String> {
		get { return mLibraryScripts }
	}

	public static func addLibraryScript(script scr: String) {
		mLibraryScripts.append(scr)
	}

	public init(ownerContext octxt: KEContext, console cons: CNConsole, config conf: KEConfig) {
		mOperation		= CNOperation()
		mOwnerContext		= octxt
		mSelfContext    	= KEContext(virtualMachine: JSVirtualMachine())
		mConsole		= cons
		mConfig			= conf
		mPropertyTable  	= KEObject(context: mSelfContext)

		mOperationObject 	= nil
		mSetFunction		= nil
		mGetFunction		= nil
		mExecFunction		= nil
		super.init()

		setExceptionHandler()
		defineProperties()
		updateOperation()
	}

	private func setExceptionHandler(){
		mSelfContext.exceptionCallback = {
			(_ exception: KEException) -> Void in
			self.mConsole.error(string: exception.description + "\n")
		}
	}

	public var operation: CNOperation {
		if let op = mOperation {
			return op
		} else {
			fatalError("No operation")
		}
	}

	public func shiftOutOperation() -> CNOperation {
		let orgop  = operation
		mOperation = CNOperation()
		updateOperation()
		return orgop
	}

	private func defineProperties() {
		mPropertyTable.set(name: CNOperation.isExecutingItem, boolValue: isExecuting)
		mPropertyTable.set(name: CNOperation.isFinishedItem,  boolValue: isFinished)
		mPropertyTable.set(name: CNOperation.isCanceledItem,  boolValue: isCancelled)
	}

	private func updateOperation() {
		operation.addIsExecutingListener(listnerFunction: {
			(_ anyval: Any?) -> Void in
			if let num = anyval as? NSNumber {
				self.mPropertyTable.set(name: CNOperation.isExecutingItem, boolValue: num.boolValue)
			} else {
				CNLog(type: .Error, message: "Not number", file: #file, line: #line, function: #function)
			}
		})
		operation.addIsFinishedListener(listnerFunction: {
			(_ anyval: Any?) -> Void in
			if let num = anyval as? NSNumber {
				self.mPropertyTable.set(name: CNOperation.isFinishedItem, boolValue: num.boolValue)
			} else {
				CNLog(type: .Error, message: "Not number", file: #file, line: #line, function: #function)
			}
		})
		operation.addIsCanceledListener(listnerFunction: {
			(_ anyval: Any?) -> Void in
			if let num = anyval as? NSNumber {
				self.mPropertyTable.set(name: CNOperation.isCanceledItem, boolValue: num.boolValue)
			} else {
				CNLog(type: .Error, message: "Not number", file: #file, line: #line, function: #function)
			}
		})
		operation.mainFunction = {
			() -> Void in
			if let op = self.mOperationObject, let execfunc = self.mExecFunction {
				let _ = execfunc.call(withArguments: [op])
			} else {
				CNLog(type: .Error, message: "No built-in object for exec", file: #file, line: #line, function: #function)
			}
		}
	}

	public var isExecuting: Bool { get { return operation.isExecuting }}
	public var isFinished:	Bool { get { return operation.isFinished  }}
	public var isCancelled: Bool { get { return operation.isCancelled }}

	public func compile(_ program: JSValue) -> JSValue {
		let compiler = KLOperationCompiler()

		let result: Bool
		if compiler.compile(operation: self, program: program, console: mConsole, config: mConfig) {
			CNLog(type: .Flow, message: "Success to compile operation", file: #file, line: #line, function: #function)
			mOperationObject 	= compiler.operation
			mSetFunction		= compiler.setFunction
			mGetFunction		= compiler.getFunction
			mExecFunction		= compiler.execFunction
			result = true
		} else {
			CNLog(type: .Error, message: "Failed to compile operation", file: #file, line: #line, function: #function)
			result = false
		}
		return JSValue(bool: result, in: mSelfContext)
	}

	public func set(_ cmdval: JSValue, _ paramref: Any) {
		let cmddup   = cmdval.copy(context: mSelfContext)
		let paramdata: Any
		if let paramval = paramref as? JSValue {
			paramdata = paramval.copy(context: mSelfContext)
		} else if let paramval = paramref as? KLEmbeddedObject {
			paramdata = paramval.copy(context: mSelfContext)
		} else {
			paramdata = paramref
		}
		if let op = mOperationObject, let setfunc = mSetFunction {
			let _ = setfunc.call(withArguments: [op, cmddup, paramdata])
		} else {
			CNLog(type: .Error, message: "No built-in object for set", file: #file, line: #line, function: #function)
		}
	}

	public func get(_ cmdval: JSValue) -> JSValue {
		let cmddup   = cmdval.copy(context: mSelfContext)
		if let op = mOperationObject, let getfunc = mGetFunction {
			if let retval = getfunc.call(withArguments: [op, cmddup]) {
				return retval.copy(context: mOwnerContext)
			} else {
				return JSValue(undefinedIn: mOwnerContext)
			}
		} else {
			CNLog(type: .Error, message: "No built-in object for get", file: #file, line: #line, function: #function)
			return JSValue(undefinedIn: mOwnerContext)
		}
	}

	public func cancel() {
		operation.cancel()
	}
}

private class KLOperationCompiler: KLCompiler
{
	public var 	operation:	JSValue?
	public var	setFunction:	JSValue?
	public var	getFunction:	JSValue?
	public var	execFunction:	JSValue?

	public func compile(operation op: KLOperation, program progval: JSValue, console cons: CNConsole, config conf: KEConfig) -> Bool {
		if super.compile(context: op.mSelfContext, console: cons, config: conf) {
			defineCoreObject(operation: op, console: cons, config: conf)
			compileOperationClass(operation: op, console: cons, config: conf)
			let res0 = compileUserScripts(operation: op, program: progval, console: cons, config: conf)
			defineBuiltinFunction(operation: op)
			return res0
		} else {
			return false
		}
	}

	private func defineCoreObject(operation op: KLOperation, console cons: CNConsole, config conf: KEConfig) {
		let context = op.mSelfContext

		/* Define Operation */
		context.set(name: "_operation_core", object: op.propertyTable)
		let _ = compile(context: context, instance: "_operation_core", object: op.propertyTable, console: cons, config: conf)

		/* Define listner for cancel operation */
		let procstmt = "_operation_core.addListener(\"\(CNOperation.isCanceledItem)\", function(newval){ if(newval){ _cancel() ; }}) ;\n"
		let _ = compile(context: context, statement: procstmt, console: cons, config: conf)
	}

	private func compileOperationClass(operation op: KLOperation, console cons: CNConsole, config conf: KEConfig) {
		/* Compile "Operation.js" */
		if let script = readResource(fileName: "Operation", fileExtension: "js", forClass: KLOperationCompiler.self) {
			let _ = compile(context: op.mSelfContext, statement: script, console: cons, config: conf)
		} else {
			CNLog(type: .Error, message: "Failed to read Operation.js", file: #file, line: #line, function: #function)
		}
	}

	private func compileUserScripts(operation op: KLOperation, program progval: JSValue, console cons: CNConsole, config conf: KEConfig) -> Bool {
		var result  = true
		let context = op.mSelfContext

		/* Compile user defined library */
		CNLog(type: .Flow, message: "Operaion: Compile library scripts", file: #file, line: #line, function: #function)
		for script in KLOperation.libraryScripts {
			let _ = super.compile(context: context, statement: script, console: cons, config: conf)
		}
		if let sym = getSymbol(symbol: "_operation_set", in: context, console: cons) {
			setFunction = sym
		} else {
			result = false
		}
		if let sym = getSymbol(symbol: "_operation_get", in: context, console: cons) {
			getFunction = sym
		} else {
			result = false
		}
		if let sym = getSymbol(symbol: "_operation_exec", in: context, console: cons) {
			execFunction = sym
		} else {
			result = false
		}

		/* Compile program */
		CNLog(type: .Flow, message: "Operaion: Compile program", file: #file, line: #line, function: #function)
		let scripts = valueToScripts(value: progval, console: cons)
		if scripts.count > 0 {
			for script in scripts {
				let _ = super.compile(context: context, statement: script, console: cons, config: conf)
			}
		} else {
			CNLog(type: .Error, message: "No user script", file: #file, line: #line, function: #function)
		}

		/* Get "operation" object */
		CNLog(type: .Flow, message: "Operaion: Get operation", file: #file, line: #line, function: #function)
		if let opval = getOperationSymbol(context: context) {
			CNLog(type: .Flow, message: "Operaion: \"operation\" variable is found", file: #file, line: #line, function: #function)
			operation = opval
		} else {
			CNLog(type: .Flow, message: "Operaion: No \"operation\" variable, define it", file: #file, line: #line, function: #function)
			let _ = super.compile(context: context, statement: "operation = new Operation(); \n", console: cons, config: conf)
			operation = getOperationSymbol(context: context)
		}

		if !checkValue(value: operation) {
			cons.error(string: "No operation object\n")
			result = false
		}

		return result
	}

	private func defineBuiltinFunction(operation op: KLOperation) {
		let context = op.mSelfContext

		/* Define exit function */
		let exitFunc = {
			(_ value: JSValue) -> JSValue in
			op.cancel()
			return JSValue(undefinedIn: op.mSelfContext)
		}
		context.set(name: "exit", function: exitFunc)
	}

	private func getOperationSymbol(context ctxt: KEContext) -> JSValue? {
		if let val = ctxt.objectForKeyedSubscript("operation") {
			if val.isObject {
				return val
			}
		}
		return nil
	}

	private func getSymbol(symbol sym: String, in context: KEContext, console cons: CNConsole) -> JSValue? {
		if let val = context.objectForKeyedSubscript(sym) {
			return val
		} else {
			cons.error(string: "Can not get variable: \"\(sym)\"\n")
			return nil
		}
	}

	private func valueToScripts(value val: JSValue, console cons: CNConsole) -> Array<String> {
		var scripts: Array<String> = []
		if val.isArray {
			if let arrval = val.toArray() {
				for elmval in arrval {
					if let elmstr = elmval as? String {
						scripts.append(elmstr)
					} else {
						cons.error(string: "Invalid data for script: \"\(elmval)\"")
					}
				}
			}
		} else if val.isString {
			if let str = val.toString() {
				scripts.append(str)
			}
		}
		return scripts
	}

	private func checkValue(value val: JSValue?) -> Bool {
		if let v = val {
			if !v.isNull && !v.isUndefined {
				return true
			}
		}
		return false
	}
}

