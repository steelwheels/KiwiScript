/**
 * @file	KEOperation.swift
 * @brief	Extend KEOperation class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import JavaScriptCore
import Foundation

public class KEOperation: Operation
{
	static public let ExecutingItem		= "isExecuting"
	static public let FinishedItem		= "isFinished"

	private var mContext:				KEContext
	private var mScript:				String
	private var mExceptionCallback:			KEContext.ExceptionCallback
	private var mObservers:				Array<NSObject>

	@objc private dynamic var mIsExecuting:		Bool
	@objc private dynamic var mIsFinished:		Bool

	public init(context ctxt: KEContext, script scr: String){
		mContext 		= ctxt
		mScript			= scr
		mExceptionCallback	= ctxt.exceptionCallback
		mIsExecuting		= false
		mIsFinished		= false
		mObservers		= []
		super.init()
		
		/* Replace exception callback */
		ctxt.exceptionCallback = {
			(_ result: KEException) -> Void in
			self.isExecuting = false
			self.isFinished  = true
			/* Call original callback here */
			self.mExceptionCallback(result)
		}
	}

	deinit {
		while mObservers.count > 0 {
			remove(observer: mObservers[0])
		}
	}

	public override var isAsynchronous: Bool {
		get { return true }
	}

	public override var isExecuting: Bool {
		get {
			return mIsExecuting
		}
		set(newval) {
			if newval != mIsExecuting {
				self.willChangeValue(forKey: KEOperation.ExecutingItem)
				mIsExecuting = newval
				self.didChangeValue(forKey: KEOperation.ExecutingItem)
			}
		}
	}

	public override var isFinished: Bool {
		get {
			return mIsFinished
		}
		set(newval) {
			if newval != mIsFinished {
				self.willChangeValue(forKey: KEOperation.FinishedItem)
				mIsFinished = newval
				self.didChangeValue(forKey: KEOperation.FinishedItem)
			}
		}
	}

	public func add(observer obs: NSObject) {
		self.addObserver(obs, forKeyPath: KEOperation.ExecutingItem, options: [.new], context: nil)
		self.addObserver(obs, forKeyPath: KEOperation.FinishedItem,  options: [.new], context: nil)
		mObservers.append(obs)
	}

	public func remove(observer obs: NSObject){
		if let idx = mObservers.index(where: {$0 === obs} ) {
			self.removeObserver(obs, forKeyPath: KEOperation.ExecutingItem)
			self.removeObserver(obs, forKeyPath: KEOperation.FinishedItem)
			mObservers.remove(at: idx)
		}
	}

	public override func start() {
		/* Change the state */
		self.isExecuting = true
		self.isFinished  = false
		/* Call main */
		self.main()
	}

	public override func main(){
		if self.isCancelled {
			/* do nothing */
		} else {
			/* Execute main operation */
			let mainscr = mainScript(script: mScript)
			let _       = mContext.evaluateScript(mainscr)
			self.isExecuting = false
			self.isFinished  = true
		}
	}

	private func mainScript(script scr: String) -> String {
		return 	"_exec(\(scr)) ;"
	}
}

