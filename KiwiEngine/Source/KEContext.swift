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

	public var exceptionCallback: ExceptionCallback

	public override init(virtualMachine vm: JSVirtualMachine) {
		exceptionCallback = {
			(_ exception: KEException) -> Void in
			NSLog("[Exception] \(exception.description)")
		}
		super.init(virtualMachine: vm)

		/* Set handler */
		self.exceptionHandler = {
			(context, exception) in
			if let ctxt = context as? KEContext {
				self.exceptionCallback(KEException.exception(ctxt, exception))
			} else {
				NSLog("[Exception] Internal error")
			}
		}
	}

	public func runScript(script scr: String!) -> JSValue {
		return super.evaluateScript(scr)
	}

	public func callFunction(functionName funcname: String, arguments args: Array<Any>) -> JSValue {
		/* Call function */
		let jsfunc : JSValue = self.objectForKeyedSubscript(funcname)
		return jsfunc.call(withArguments: args)
	}

	public func set(name n: String, object o: JSExport){
		self.setObject(o, forKeyedSubscript: NSString(string: n))
	}
	
	public func set(name n: String, value val: JSValue){
		self.setObject(val, forKeyedSubscript: NSString(string: n))
	}

	public func getValue(name n:String) -> JSValue? {
		return self.objectForKeyedSubscript(NSString(string: n))
	}
}

