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
	public class func runScript(context ctxt: KEContext, script scr: String) -> (result: JSValue?, errors: Array<NSError>?){
		let retval = ctxt.evaluateScript(scr)
		let errcnt = ctxt.runtimeErrors().count ;
		if(errcnt == 0){
			return (retval, nil)
		} else {
			let errors = ctxt.runtimeErrors()
			ctxt.clearRuntimeErrors()
			return (nil, errors)
		}
	}

	public class func callFunction(context ctxt: KEContext, functionName funcname: String, arguments args: Array<AnyObject>) -> (result: JSValue?, errors: Array<NSError>?){
		let jsfunc : JSValue = ctxt.objectForKeyedSubscript(funcname)
		let retval = jsfunc.call(withArguments: args)
		let errcnt = ctxt.runtimeErrors().count ;
		if(errcnt == 0){
			return (retval, nil)
		} else {
			let errors = ctxt.runtimeErrors()
			ctxt.clearRuntimeErrors()
			return (nil, errors)
		}
	}
}

