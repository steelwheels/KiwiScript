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
	public class func runScript(context: KEContext, script : String) -> (result: JSValue?, errors: Array<NSError>?){
		let retval = context.evaluateScript(script)
		let errcnt = context.runtimeErrors().count ;
		if(errcnt == 0){
			return (retval, nil)
		} else {
			let errors = context.runtimeErrors()
			context.clearRuntimeErrors()
			return (nil, errors)
		}
	}

	public class func callFunction(context: KEContext, functionName funcname: String, arguments: Array<AnyObject>) -> (result: JSValue?, errors: Array<NSError>?){
		let jsfunc : JSValue = context.objectForKeyedSubscript(funcname)
		let retval = jsfunc.callWithArguments(arguments)
		let errcnt = context.runtimeErrors().count ;
		if(errcnt == 0){
			return (retval, nil)
		} else {
			let errors = context.runtimeErrors()
			context.clearRuntimeErrors()
			return (nil, errors)
		}
	}
}

