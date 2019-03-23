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

	func set(_ cmdid: JSValue, _ param: JSValue)
	func get(_ cmdid: JSValue) -> JSValue
}

@objc public class KLOperation: CNOperation, KLOperationProtocol
{
	public static var mLibraryScripts: Array<String> 	= []

	private var	mOwnerContext:	KEContext
	fileprivate var	mSelfContext:	KEContext
	private var	mConsole:	CNConsole
	private var	mConfig:	KEConfig
	private var	mPropertyTable:	KEObject

	private var 	mOperation:	JSValue?
	private var	mSetFunction:	JSValue?
	private var	mGetFunction:	JSValue?
	private var	mExecFunction:	JSValue?


	public var propertyTable: KEObject	{ get { return mPropertyTable }}

	public static var libraryScripts: Array<String> {
		get { return mLibraryScripts }
	}

	public static func addLibraryScript(script scr: String) {
		mLibraryScripts.append(scr)
	}

	public init(ownerContext octxt: KEContext, console cons: CNConsole, config conf: KEConfig) {
		mOwnerContext	= octxt
		mSelfContext    = KEContext(virtualMachine: JSVirtualMachine())
		mConsole	= cons
		mConfig		= conf
		mPropertyTable  = KEObject(context: mSelfContext)

		mOperation 	= nil
		mSetFunction	= nil
		mGetFunction	= nil
		mExecFunction	= nil
		super.init()

		setExceptionHandler()
		defineProperties()
		defineMainFunction()
	}

	private func setExceptionHandler(){
		mSelfContext.exceptionCallback = {
			(_ exception: KEException) -> Void in
			self.mConsole.error(string: exception.description + "\n")
		}
	}

	private func defineProperties() {
		mPropertyTable.set(name: CNOperation.isExecutingItem, boolValue: isExecuting)
		mPropertyTable.set(name: CNOperation.isFinishedItem,  boolValue: isFinished)
		mPropertyTable.set(name: CNOperation.isCanceledItem,  boolValue: isCancelled)

		/* Add listener function to update property */
		self.addIsExecutingListener(listnerFunction: {
			(_ anyval: Any?) -> Void in
			if let num = anyval as? NSNumber {
				self.mPropertyTable.set(name: CNOperation.isExecutingItem, boolValue: num.boolValue)
			} else {
				CNLog(type: .Error, message: "Not number", file: #file, line: #line, function: #function)
			}
		})
		self.addIsFinishedListener(listnerFunction: {
			(_ anyval: Any?) -> Void in
			if let num = anyval as? NSNumber {
				self.mPropertyTable.set(name: CNOperation.isFinishedItem, boolValue: num.boolValue)
			} else {
				CNLog(type: .Error, message: "Not number", file: #file, line: #line, function: #function)
			}
		})
		self.addIsCanceledListener(listnerFunction: {
			(_ anyval: Any?) -> Void in
			if let num = anyval as? NSNumber {
				self.mPropertyTable.set(name: CNOperation.isCanceledItem, boolValue: num.boolValue)
			} else {
				CNLog(type: .Error, message: "Not number", file: #file, line: #line, function: #function)
			}
		})
	}

	private func defineMainFunction() {
		self.mainFunction = {
			() -> Void in
			if let op = self.mOperation, let execfunc = self.mExecFunction {
				let _ = execfunc.call(withArguments: [op])
			} else {
				CNLog(type: .Error, message: "No built-in object for exec", file: #file, line: #line, function: #function)
			}
		}
	}

	public func compile(_ program: JSValue) -> JSValue {
		let compiler = KLOperationCompiler(console: mConsole, config: mConfig)

		let result: Bool
		if compiler.compile(operation: self, program: program) {
			CNLog(type: .Flow, message: "Success to compile operation", file: #file, line: #line, function: #function)
			mOperation 	= compiler.operation
			mSetFunction	= compiler.setFunction
			mGetFunction	= compiler.getFunction
			mExecFunction	= compiler.execFunction
			result = true
		} else {
			CNLog(type: .Error, message: "Failed to compile operation", file: #file, line: #line, function: #function)
			result = false
		}
		return JSValue(bool: result, in: mSelfContext)
	}

	public func set(_ cmdval: JSValue, _ paramval: JSValue) {
		let cmddup   = cmdval.duplicate(context: mSelfContext)
		let paramdup = paramval.duplicate(context: mSelfContext)
		if let op = mOperation, let setfunc = mSetFunction {
			CNLog(type: .Flow, message: "operation.set", file: #file, line: #line, function: #function)
			let _ = setfunc.call(withArguments: [op, cmddup, paramdup])
		} else {
			CNLog(type: .Error, message: "No built-in object for set", file: #file, line: #line, function: #function)
		}
	}

	public func get(_ cmdval: JSValue) -> JSValue {
		let cmddup   = cmdval.duplicate(context: mSelfContext)
		if let op = mOperation, let getfunc = mGetFunction {
			CNLog(type: .Flow, message: "operation.get", file: #file, line: #line, function: #function)
			if let retval = getfunc.call(withArguments: [op, cmddup]) {
				return retval.duplicate(context: mOwnerContext)
			} else {
				return JSValue(undefinedIn: mOwnerContext)
			}
		} else {
			CNLog(type: .Error, message: "No built-in object for get", file: #file, line: #line, function: #function)
			return JSValue(undefinedIn: mOwnerContext)
		}
	}
}

private class KLOperationCompiler: KLCompiler
{
	public var 	operation:	JSValue?
	public var	setFunction:	JSValue?
	public var	getFunction:	JSValue?
	public var	execFunction:	JSValue?

	public func compile(operation op: KLOperation, program progval: JSValue) -> Bool {
		if super.compile(context: op.mSelfContext) {
			defineCoreObject(operation: op)
			compileOperationClass(operation: op)
			let res0 = compileUserScripts(operation: op, program: progval)
			defineBuiltinFunction(operation: op)
			return res0
		} else {
			return false
		}
	}

	private func defineCoreObject(operation op: KLOperation) {
		let context = op.mSelfContext

		/* Define Operation */
		context.set(name: "_operation_core", object: op.propertyTable)
		let _ = compile(context: context, instance: "_operation_core", object: op.propertyTable)

		/* Define listner for cancel operation */
		let procstmt = "_operation_core.addListener(\"\(KLOperation.isCanceledItem)\", function(newval){ if(newval){ _cancel() ; }}) ;\n"
		let _ = compile(context: context, statement: procstmt)
	}

	private func compileOperationClass(operation op: KLOperation) {
		/* Compile "Operation.js" */
		if let script = readResource(fileName: "Operation", fileExtension: "js", forClass: KLOperationCompiler.self) {
			let _ = compile(context: op.mSelfContext, statement: script)
		} else {
			CNLog(type: .Error, message: "Failed to read Operation.js", file: #file, line: #line, function: #function)
		}
	}

	private func compileUserScripts(operation op: KLOperation, program progval: JSValue) -> Bool {
		var result  = true
		let context = op.mSelfContext

		/* Compile user defined library */
		CNLog(type: .Flow, message: "Operaion: Compile library scripts", file: #file, line: #line, function: #function)
		for script in KLOperation.libraryScripts {
			let _ = super.compile(context: context, statement: script)
		}
		if let sym = getSymbol(symbol: "_operation_set", in: context) {
			setFunction = sym
		} else {
			result = false
		}
		if let sym = getSymbol(symbol: "_operation_get", in: context) {
			getFunction = sym
		} else {
			result = false
		}
		if let sym = getSymbol(symbol: "_operation_exec", in: context) {
			execFunction = sym
		} else {
			result = false
		}

		/* Compile program */
		CNLog(type: .Flow, message: "Operaion: Compile program", file: #file, line: #line, function: #function)
		if let program = valueToString(value: progval) {
			let _ = super.compile(context: context, statement: program)
		}

		/* Get "operation" object */
		CNLog(type: .Flow, message: "Operaion: Get operation", file: #file, line: #line, function: #function)
		if let opval = getOperationSymbol(context: context) {
			CNLog(type: .Flow, message: "Operaion: \"operation\" variable is found", file: #file, line: #line, function: #function)
			operation = opval
		} else {
			CNLog(type: .Flow, message: "Operaion: No \"operation\" variable, define it", file: #file, line: #line, function: #function)
			let _ = super.compile(context: context, statement: "operation = new Operation(); \n")
			operation = getOperationSymbol(context: context)
		}

		if !checkValue(value: operation) {
			console.error(string: "No operation object\n")
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

	private func getSymbol(symbol sym: String, in context: KEContext) -> JSValue? {
		if let val = context.objectForKeyedSubscript(sym) {
			return val
		} else {
			console.error(string: "Can not get variable: \"\(sym)\"\n")
			return nil
		}
	}

	private func valueToString(value val: JSValue) -> String? {
		if val.isString {
			if let str = val.toString() {
				return str
			}
		}
		return nil
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

