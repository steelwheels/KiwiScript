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
	var parameter:		JSValue { get set }
	var input:		JSValue { get set }
	var output:		JSValue { get }

	func compile(_ program: JSValue, _ mainfunc: JSValue) -> JSValue
}

@objc public class KLOperation: CNOperation, KLOperationProtocol
{
	private static let parameterItem	= "parameter"
	private static let inputItem		= "input"
	private static let outputItem		= "output"

	private var	mOwnerContext:	KEContext
	fileprivate var	mSelfContext:	KEContext
	private var	mConsole:	CNConsole
	private var	mConfig:	KEConfig
	private var	mPropertyTable:	KEObject
	private var	mMainFunc:	JSValue?

	public var propertyTable: KEObject	{ get { return mPropertyTable }}

	public init(ownerContext octxt: KEContext, console cons: CNConsole, config conf: KEConfig) {
		mOwnerContext	= octxt
		mSelfContext    = KEContext(virtualMachine: JSVirtualMachine())
		mConsole	= cons
		mConfig		= conf
		mPropertyTable  = KEObject(context: mSelfContext)
		mMainFunc	= nil
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

		mPropertyTable.set(KLOperation.parameterItem,	JSValue(nullIn: mSelfContext))
		mPropertyTable.set(KLOperation.inputItem,  	JSValue(nullIn: mSelfContext))
		mPropertyTable.set(KLOperation.outputItem, 	JSValue(nullIn: mSelfContext))

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
		super.mainFunction = {
			() -> Void in
			if let mainfunc = self.mMainFunc {
				if let execfunc = self.mSelfContext.getValue(name: "_exec_cancelable") {
					execfunc.call(withArguments: [mainfunc])
				} else {
					CNLog(type: .Error, message: "No exec func", file: #file, line: #line, function: #function)
				}
			}
		}
	}

	public var parameter: JSValue {
		get {
			if let val = mPropertyTable.get(KLOperation.parameterItem) as? JSValue {
				return val
			} else {
				CNLog(type: .Error, message: "Unexpected value", file: #file, line: #line, function: #function)
				return JSValue(undefinedIn: mSelfContext)
			}
		}
		set(val){
			let dupval = val.duplicate(context: mSelfContext)
			mPropertyTable.set(KLOperation.parameterItem, dupval)
		}
	}

	public var input: JSValue {
		get {
			if let val = mPropertyTable.get(KLOperation.inputItem) as? JSValue {
				return val
			} else {
				CNLog(type: .Error, message: "Unexpected value", file: #file, line: #line, function: #function)
				return JSValue(undefinedIn: mSelfContext)
			}
		}
		set(val){
			let dupval = val.duplicate(context: mSelfContext)
			mPropertyTable.set(KLOperation.inputItem, dupval)
		}
	}

	public var output: JSValue {
		get {
			if let val = mPropertyTable.get(KLOperation.outputItem) as? JSValue {
				return val.duplicate(context: mOwnerContext)
			} else {
				CNLog(type: .Error, message: "Unexpected value", file: #file, line: #line, function: #function)
				return JSValue(undefinedIn: mOwnerContext)
			}
		}
	}

	public func compile(_ program: JSValue, _ mainfunc: JSValue) -> JSValue {
		let compiler = KLOperationCompiler(console: mConsole, config: mConfig)
		if let mainfunc = compiler.compile(operation: self, program: program, mainFunction: mainfunc) {
			CNLog(type: .Flow, message: "Success to compile operation", file: #file, line: #line, function: #function)
			mMainFunc = mainfunc
		} else {
			CNLog(type: .Error, message: "Failed to compile operation", file: #file, line: #line, function: #function)
		}
		return JSValue(bool: mMainFunc != nil, in: mSelfContext)
	}
}

private class KLOperationCompiler: KLCompiler
{
	public func compile(operation op: KLOperation, program progval: JSValue, mainFunction mainval: JSValue) -> JSValue? {
		if super.compile(context: op.mSelfContext) {
			compileOperation(operation: op)
			defineOperationInstance(operation: op)
			defineExitFunction(operation: op)
			return compileSource(operation: op, program: progval, mainFunction: mainval)
		} else {
			return nil
		}
	}

	private func compileOperation(operation op: KLOperation) {
		/* Compile "Operation.js" */
		if let script = readResource(fileName: "Operation", fileExtension: "js", forClass: KLOperationCompiler.self) {
			let _ = compile(context: op.mSelfContext, statement: script)
		} else {
			CNLog(type: .Error, message: "Failed to read Operation.js", file: #file, line: #line, function: #function)
		}
	}

	private func defineOperationInstance(operation op: KLOperation){
		let context = op.mSelfContext

		/* Define global variable: Process */
		let opname = "Operation"
		context.set(name: opname, object: op.propertyTable)
		compile(context: context, instance: opname, object: op.propertyTable)

		/* Define special method for each applications */
		let procstmt = "\(opname).addListener(\"\(KLOperation.isCanceledItem)\", function(newval){ if(newval){ _cancel() ; }}) ;\n"
		let _ = compile(context: context, statement: procstmt)
	}

	private func defineExitFunction(operation op: KLOperation) {
		/* Define exit function */
		let exitFunc = {
			(_ value: JSValue) -> JSValue in
			op.cancel()
			return JSValue(undefinedIn: op.mSelfContext)
		}
		op.mSelfContext.set(name: "exit", function: exitFunc)
	}

	private func compileSource(operation op: KLOperation, program progval: JSValue, mainFunction mainval: JSValue) -> JSValue? {
		let context = op.mSelfContext

		/* Compile program */
		if let program = valueToString(value: progval) {
			let _ = super.compile(context: context, statement: program)
		}
		/* Compile main function */
		var mainfunc: JSValue? = nil
		if let maindecl = valueToString(value: mainval) {
			let mainexp: String = "_main = \(maindecl) ;\n"
			let _ = super.compile(context: context, statement: mainexp)

			if let funcval = context.objectForKeyedSubscript("_main") {
				mainfunc = funcval
			} else {
				CNLog(type: .Error, message: "Can not get main function", file: #file, line: #line, function: #function)
			}
		}
		return mainfunc
	}

	private func valueToString(value val: JSValue) -> String? {
		if val.isString {
			if let str = val.toString() {
				return str
			}
		}
		return nil
	}
}

