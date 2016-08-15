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
				context.addErrorMessage(exception.description) ;
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
	
	public func addErrorMessage(message : NSString){
		let error = NSError.parseError(message: message) ;
		mRuntimeErrors.append(error)
	}

	public func addGlobalObject(name: NSString, value: NSObject){
		self.setObject(value, forKeyedSubscript:name)
	}
	
	public func allocateObjectValue(value : NSObject) -> JSValue {
		 return JSValue(object: value, inContext: self)
	}
}

