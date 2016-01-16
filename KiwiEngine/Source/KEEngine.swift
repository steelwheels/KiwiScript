/**
 * @file	KEEngine.swift
 * @brief	Extend KEEngine class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation
import JavaScriptCore

public class KEEngine : NSObject
{
	internal var	virtualMachine	: JSVirtualMachine
	internal var	mContext	: KEContext

	public override init() {
		virtualMachine = JSVirtualMachine()
		mContext = KEContext(virtualMachine: virtualMachine)
		super.init()
		setupContext()
	}

	public init(vm : JSVirtualMachine) {
		virtualMachine = vm
		mContext = KEContext(virtualMachine: vm)
		super.init()
		setupContext()
	}

	public func context() -> KEContext {
		return mContext
	}

	public func clearContext() {
		virtualMachine = JSVirtualMachine()
		mContext = KEContext(virtualMachine: virtualMachine)
		setupContext()
	}

	private func setupContext() {
		mContext.exceptionHandler = { contextp, exception in
			if let context = contextp as? KEContext {
				context.addErrorMessage(exception.description) ;
				return
			}
			NSLog("Internal error \(exception)")
		}
	}

	public func runScript(script : String) -> (result: JSValue?, errors: Array<NSError>?){
		let retval = mContext.evaluateScript(script)
		let errcnt = mContext.runtimeErrors().count ;
		if(errcnt == 0){
			return (retval, nil)
		} else {
			let errors = mContext.runtimeErrors()
			mContext.clearRuntimeErrors()
			return (nil, errors)
		}
	}

	public func callFunction(funcname : String, arguments: Array<AnyObject>) -> (result: JSValue?, errors: Array<NSError>?){
		let jsfunc : JSValue = mContext.objectForKeyedSubscript(funcname)
		let retval = jsfunc.callWithArguments(arguments)
		let errcnt = mContext.runtimeErrors().count ;
		if(errcnt == 0){
			return (retval, nil)
		} else {
			let errors = mContext.runtimeErrors()
			mContext.clearRuntimeErrors()
			return (nil, errors)
		}
	}
}

