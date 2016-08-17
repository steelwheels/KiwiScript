/**
 * @file	KEContext.swift
 * @brief	Extend KEContext class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation
import JavaScriptCore
import Canary

public class KEContext : JSContext
{
	private var mRuntimeErrors : Array<NSError> = [] ;
	
	public override init(virtualMachine: JSVirtualMachine!) {
		super.init(virtualMachine: virtualMachine)
		self.exceptionHandler = { contextp, exception in
			if let context = contextp as? KEContext {
				context.addErrorMessage(message: exception.description) ;
				return
			}
			NSLog("Internal error \(exception)")
		}
	}
	
	public func runtimeErrors() -> Array<NSError> {
		return mRuntimeErrors ;
	}
	
	public func clearRuntimeErrors() {
		mRuntimeErrors = []
	}
	
	public func addErrorMessage(message msg : NSString){
		let error = NSError.parseError(message: msg) ;
		mRuntimeErrors.append(error)
	}

	public func addGlobalObject(name n: NSString, object o: NSObject){
		self.setObject(o, forKeyedSubscript:n)
	}
	
	public func allocateObjectValue(object o: NSObject) -> JSValue {
		 return JSValue(object: o, inContext: self)
	}
}

