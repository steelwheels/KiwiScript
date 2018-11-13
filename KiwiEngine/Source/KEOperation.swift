/**
 * @file	KEOperation.swift
 * @brief	Extend KEOperation class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import CoconutData
import JavaScriptCore
import Foundation

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
	private var mContext:		KEContext
	private var mProcess:		KEOperationProcess
	private var mArguments:		Array<JSValue>

	public init(context ctxt: KEContext, process proc: KEOperationProcess, arguments args: Array<JSValue>){
		mContext	= ctxt
		mProcess	= proc
		mArguments	= args
	}

	public override var isExecuting: Bool {
		get {
			return super.isExecuting
		}
		set(newval) {
			mProcess.isExecuting = newval
			super.isExecuting = newval
		}
	}

	public override var isFinished: Bool {
		get {
			return super.isFinished
		}
		set(newval){
			mProcess.isFinished = newval
			super.isFinished = newval
		}
	}

	public override var isCancelled: Bool {
		get {
			return super.isCancelled
		}
		set(newval){
			mProcess.isCanceled = newval
			super.isCancelled = newval
		}
	}

	public override func mainOperation() {
		if let execfunc = mContext.objectForKeyedSubscript("_exec_cancelable"),
		   let mainfunc = mContext.objectForKeyedSubscript("main") {
			execfunc.call(withArguments: [mainfunc, mArguments])
		}
	}
}
