/**
 * @file	KEContext.swift
 * @brief	Extend KEContext class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation
import JavaScriptCore
import CoconutData

public class KEContext : JSContext
{
	public typealias ExceptionCallback =  (_ exception: KEException) -> Void

	public var exceptionCallback	: ExceptionCallback
	public var mDispatchSemaphore	: DispatchSemaphore?
	private var mErrorCount		: Int

	private var dispatchSemaphore: DispatchSemaphore {
		get {
			if let sem = mDispatchSemaphore {
				return sem
			} else {
				let sem = DispatchSemaphore(value: 0)
				mDispatchSemaphore = sem
				return sem
			}
		}
	}

	public override init(virtualMachine vm: JSVirtualMachine) {
		exceptionCallback = {
			(_ exception: KEException) -> Void in
			NSLog("JavaScriptCore [Exception] \(exception.description)")
		}
		mDispatchSemaphore	= nil
		mErrorCount		= 0
		super.init(virtualMachine: vm)

		/* Set handler */
		self.exceptionHandler = {
			[weak self] (context, exception) in
			if let myself = self, let ctxt = context as? KEContext {
				let except = KEException(context: ctxt, value: exception)
				myself.exceptionCallback(except)
				myself.mErrorCount += 1
			} else {
				NSLog("Internal error")
			}
		}
	}

	public func callFunction(functionName funcname: String, arguments args: Array<Any>) -> JSValue {
		/* Call function */
		let jsfunc : JSValue = self.objectForKeyedSubscript(funcname)
		return jsfunc.call(withArguments: args)
	}

	public var errorCount: Int { get { return mErrorCount }}

	public func set(name n: String, object o: JSExport){
		self.setObject(o, forKeyedSubscript: NSString(string: n))
	}
	
	public func set(name n: String, value val: JSValue){
		self.setObject(val, forKeyedSubscript: NSString(string: n))
	}

	public func set(name n: String, function obj: Any){
		if let val = JSValue(object: obj, in: self){
			set(name: n, value: val)
		} else {
			NSLog("Can not allocate value")
		}
	}

	public func getValue(name n:String) -> JSValue? {
		return self.objectForKeyedSubscript(NSString(string: n))
	}

	public func suspend() {
		self.dispatchSemaphore.wait()
	}

	public func resume() {
		self.dispatchSemaphore.signal()
	}
}

