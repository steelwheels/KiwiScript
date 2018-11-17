/**
 * @file	KEOperation.swift
 * @brief	Extend KEOperation class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import CoconutData
import JavaScriptCore
import Foundation

public struct KEOperationContext {
	public var	context: 	KEContext
	public var	process:	KEOperationProcess

	public init(context ctxt: KEContext){
		context	= ctxt
		process	= KEOperationProcess(context: ctxt)
	}
}

public class KEOperationProcess: KEObject
{
	private static let isExecutingItem	= "isExecuting"
	private static let isFinishedItem	= "isFinished"
	private static let isCanceledItem	= "isCanceled"

	public override init(context ctxt: KEContext) {
		super.init(context: ctxt)

		isExecuting	= false
		isFinished	= false
		isCanceled	= false
	}
	public var isExecuting: Bool {
		get	   { return getBoolean(name: KEOperationProcess.isExecutingItem) }
		set(value) { set(name: KEOperationProcess.isExecutingItem, booleanValue: value) }
	}

	public var isFinished: Bool {
		get	   { return getBoolean(name: KEOperationProcess.isFinishedItem) }
		set(value) { set(name: KEOperationProcess.isFinishedItem, booleanValue: value) }
	}

	public var isCanceled: Bool {
		get	   { return getBoolean(name: KEOperationProcess.isCanceledItem) }
		set(value) { set(name: KEOperationProcess.isCanceledItem, booleanValue: value) }
	}

	private func getBoolean(name nm: String) -> Bool {
		let val = super.get(KEOperationProcess.isExecutingItem)
		if val.isBoolean {
			return val.toBool()
		} else {
			fatalError("Invalid object at \(#function)")
		}
	}

	private func set(name nm: String, booleanValue value: Bool) {
		if let valobj = JSValue(bool: value, in: context) {
			super.set(nm, valobj)
		}
	}
}

public class KEOperation: CNOperation
{
	public typealias FinalizeCallback = (_ exitcode: CNExitCode, _ context: KEOperationContext) -> Void

	private var mContext:		KEOperationContext
	private var mArguments:		Array<JSValue>
	private var mExitCode:		CNExitCode?

	private var finalizer:		FinalizeCallback?

	public init(context ctxt: KEOperationContext, arguments args: Array<JSValue>){
		mContext	= ctxt
		mArguments	= args
		mExitCode	= nil
		finalizer	= nil
	}

	public override var isExecuting: Bool {
		get {
			return super.isExecuting
		}
		set(newval) {
			mContext.process.isExecuting = newval
			super.isExecuting = newval
		}
	}

	public override var isFinished: Bool {
		get {
			return super.isFinished
		}
		set(newval){
			mContext.process.isFinished = newval
			super.isFinished = newval
		}
	}

	public override var isCancelled: Bool {
		get {
			return super.isCancelled
		}
		set(newval){
			mContext.process.isCanceled = newval
			super.isCancelled = newval
		}
	}

	public var exitCode: CNExitCode? {
		get { return mExitCode }
	}
	
	public override func mainOperation() {
		if let execfunc = mContext.context.objectForKeyedSubscript("_exec_cancelable"),
		   let mainfunc = mContext.context.objectForKeyedSubscript("main") {
			let retval = execfunc.call(withArguments: [mainfunc, mArguments])
			let code   = valueToExitCode(value: retval)
			mExitCode  = code
			if let fin = finalizer {
				fin(code, mContext)
			}
		}
	}

	private func valueToExitCode(value val: JSValue?) -> CNExitCode {
		var result: CNExitCode = .InternalError
		if let v = val {
			if v.isNumber {
				if let err = CNExitCode(rawValue: v.toInt32()) {
					result = err
				}
			}
		}
		return result
	}
}
