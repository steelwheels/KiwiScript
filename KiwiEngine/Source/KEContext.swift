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
			CNLog(type: .Error, message: exception.description, file: #file, line: #line, function: #function)
		}
		super.init(virtualMachine: vm)

		/* Set handler */
		self.exceptionHandler = {
			[weak self] (context, exception) in
			if let myself = self, let ctxt = context as? KEContext {
				let except = KEException(context: ctxt, value: exception)
				myself.exceptionCallback(except)
			} else {
				CNLog(type: .Error, message: "Internal error", file: #file, line: #line, function: #function)
			}
		}
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

	public func set(name n: String, function obj: Any){
		if let val = JSValue(object: obj, in: self){
			set(name: n, value: val)
		} else {
			CNLog(type: .Error, message: "Can not allocate value", file: #file, line: #line, function: #function)
		}
	}

	public func getValue(name n:String) -> JSValue? {
		return self.objectForKeyedSubscript(NSString(string: n))
	}
}

