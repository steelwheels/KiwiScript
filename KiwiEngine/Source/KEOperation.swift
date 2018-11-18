/**
 * @file	KEOperation.swift
 * @brief	Extend KEOperation class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import CoconutData
import JavaScriptCore
import Foundation

public class KEOperation: CNOperation
{
	public typealias FinalizeCallback = (_ exitcode: CNExitCode, _ context: KEContext, _ process: KEProcess) -> Void

	private var mContext:		KEContext
	private var mProcess:		KEProcess
	private var mArguments:		Array<JSValue>
	private var mExitCode:		CNExitCode?

	private var finalizer:		FinalizeCallback?

	public init(context ctxt: KEContext, process proc: KEProcess, arguments args: Array<JSValue>){
		mContext	= ctxt
		mProcess	= proc
		mArguments	= args
		mExitCode	= nil
		finalizer	= nil
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

	public var exitCode: CNExitCode? {
		get { return mExitCode }
	}
	
	public override func mainOperation() {
		if let execfunc = mContext.objectForKeyedSubscript("_exec_cancelable"),
		   let mainfunc = mContext.objectForKeyedSubscript("main") {
			let retval = execfunc.call(withArguments: [mainfunc, mArguments])
			let code   = valueToExitCode(value: retval)
			mExitCode  = code
			if let fin = finalizer {
				fin(code, mContext, mProcess)
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
