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
	public typealias ExceptionCallback =  (_ result: KEException) -> Void

	public var exceptionCallback: ExceptionCallback

	public override init(virtualMachine vm: JSVirtualMachine) {
		exceptionCallback = {
			(_ result: KEException) -> Void in
			let msg = result.description
			NSLog("[Exception] \(msg)")
		}
		super.init(virtualMachine: vm)

		/* Set handler */
		self.exceptionHandler = {
			(contextp, exception) in
			let message: String
			if let e = exception {
				message = e.description
			} else {
				message = "Unknow exception"
			}
			self.exceptionCallback(KEException.CompileError(message))
		}
	}


	public func runScript(script scr: String!)  {
		/* Evaluate script */
		let retval = super.evaluateScript(scr)

		/* Call handler with return value */
		let result = KEException.Evaluated(self, retval)
		self.exceptionCallback(result)
	}

	public func callFunction(functionName funcname: String, arguments args: Array<Any>) {
		/* Call function */
		let jsfunc : JSValue = self.objectForKeyedSubscript(funcname)
		let retval = jsfunc.call(withArguments: args)

		/* Call handler with return value */
		let result = KEException.Evaluated(self, retval)
		self.exceptionCallback(result)
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

