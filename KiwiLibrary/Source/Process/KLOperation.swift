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
	var inputParameter:	JSValue { get set }
	var outputParameter:	JSValue { get }

	func compile(_ program: JSValue, _ mainfunc: JSValue) -> JSValue
}

@objc public class KLOperation: CNOperation, KLOperationProtocol
{
	private static let inputParameterItem	= "input"
	private static let outputParameterItem	= "output"

	private var mContext:		KEContext
	private var mConsole:		CNConsole
	private var mConfig:		KLConfig
	private var mPropertyTable:	KEObject
	private var mMainFunc:		JSValue?

	public var context: KEContext		{ get { return mContext }}
	public var propertyTable: KEObject	{ get { return mPropertyTable }}

	public init(console cons: CNConsole, config conf: KLConfig) {
		mContext        = KEContext(virtualMachine: JSVirtualMachine())
		mConsole	= cons
		mConfig		= conf
		mPropertyTable  = KEObject(context: mContext)
		mMainFunc	= nil
		super.init()

		defineProperties()
		defineMainFunction()
	}

	private func defineProperties() {
		mPropertyTable.set(name: CNOperation.isExecutingItem, boolValue: isExecuting)
		mPropertyTable.set(name: CNOperation.isFinishedItem,  boolValue: isFinished)
		mPropertyTable.set(name: CNOperation.isCanceledItem,  boolValue: isCancelled)

		mPropertyTable.set(KLOperation.inputParameterItem,  JSValue(nullIn: mContext))
		mPropertyTable.set(KLOperation.outputParameterItem, JSValue(nullIn: mContext))

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
				if let execfunc = self.mContext.getValue(name: "_exec_cancelable") {
					execfunc.call(withArguments: [mainfunc])
				} else {
					CNLog(type: .Error, message: "No exec func", file: #file, line: #line, function: #function)
				}
			}
		}
	}

	public var inputParameter: JSValue {
		get {
			if let val = mPropertyTable.get(KLOperation.inputParameterItem) as? JSValue {
				return val
			} else {
				CNLog(type: .Error, message: "Unexpected value", file: #file, line: #line, function: #function)
				return JSValue(undefinedIn: mContext)
			}
		}
		set(val){
			mPropertyTable.set(KLOperation.inputParameterItem, val)
		}
	}

	public var outputParameter: JSValue {
		get {
			if let val = mPropertyTable.get(KLOperation.outputParameterItem) as? JSValue {
				return val
			} else {
				CNLog(type: .Error, message: "Unexpected value", file: #file, line: #line, function: #function)
				return JSValue(undefinedIn: mContext)
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
		return JSValue(bool: mMainFunc != nil, in: mContext)
	}
}

private class KLOperationCompiler: KLCompiler
{
	public func compile(operation op: KLOperation, program progval: JSValue, mainFunction mainval: JSValue) -> JSValue? {
		if super.compile(context: op.context) {
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
			let _ = compile(context: op.context, statement: script)
		} else {
			CNLog(type: .Error, message: "Failed to read Operation.js", file: #file, line: #line, function: #function)
		}
	}

	private func defineOperationInstance(operation op: KLOperation){
		let context = op.context

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
			return JSValue(undefinedIn: op.context)
		}
		op.context.set(name: "exit", function: exitFunc)
	}

	private func compileSource(operation op: KLOperation, program progval: JSValue, mainFunction mainval: JSValue) -> JSValue? {
		let context = op.context

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

