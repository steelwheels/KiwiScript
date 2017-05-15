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
	private var mRuntimeErrors : Array<String> = [] ;
	
	public override init(virtualMachine vm: JSVirtualMachine!) {
		super.init(virtualMachine: vm)
		self.exceptionHandler = { (contextp, exception) in
			if let context = contextp as? KEContext {
				var msg: String
				if let e = exception {
					msg = e.description
				} else {
					msg = "Unknown exception"
				}
				context.addErrorMessage(message: msg) ;
				return
			}
			var desc: String = ""
			if let e = exception {
				desc = e.description
			}
			NSLog("Internal error \(desc)")
		}
	}
	
	public func runtimeErrors() -> Array<String> {
		return mRuntimeErrors ;
	}
	
	public func clearRuntimeErrors() {
		mRuntimeErrors = []
	}
	
	public func addErrorMessage(message msg : String){
		mRuntimeErrors.append(msg)
	}

	public func addGlobalObject(name n: NSString, object o: NSObject){
		self.setObject(o, forKeyedSubscript:n)
	}
	
	public func allocateObjectValue(object o: NSObject) -> JSValue {
		 return JSValue(object: o, in: self)
	}
}

