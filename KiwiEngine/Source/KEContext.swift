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
	public override init(virtualMachine vm: JSVirtualMachine) {
		super.init(virtualMachine: vm)
	}

	public func runScript(script scr: String!, exceptionHandler fhandler: @escaping (_ result: KEException) -> Void)  {
		/* Set exception handler */
		setExceptionHandler(finalizeHandler: fhandler)

		/* Evaluate script */
		let retval = super.evaluateScript(scr)

		/* Call handler with return value */
		let result = KEException.Evaluated(self, retval)
		fhandler(result)
	}

	public func callFunction(functionName funcname: String, arguments args: Array<Any>, exceptionHandler fhandler: @escaping (_ result: KEException) -> Void) {
		/* Set exception handler */
		setExceptionHandler(finalizeHandler: fhandler)

		/* Call function */
		let jsfunc : JSValue = self.objectForKeyedSubscript(funcname)
		let retval = jsfunc.call(withArguments: args)

		/* Call handler with return value */
		let result = KEException.Evaluated(self, retval)
		fhandler(result)
	}

	private func setExceptionHandler(finalizeHandler fhandler: @escaping (_ result: KEException) -> Void) {
		self.exceptionHandler = { (contextp, exception) in
			var message: String
			if let e = exception {
				message = e.description
			} else {
				message = "Unknown exception"
			}
			/* Call handler with exception */
			let result = KEException.Terminated(self, message)
			fhandler(result)
		}
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

