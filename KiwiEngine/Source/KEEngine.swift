/**
* @file		KEEngine.swift
* @brief	Extend KEEngine class
* @par Copyright
*   Copyright (C) 2015 Steel Wheels Project
*/

import Foundation
import JavaScriptCore

public class KEEngine : NSObject
{
	internal var	virtualMachine    : JSVirtualMachine
	internal var	javaScriptContext : KEContext

	override init() {
		virtualMachine = JSVirtualMachine()
		javaScriptContext = KEContext(virtualMachine: virtualMachine)
		super.init()
		setupContext()
	}
	
	public func clearContext() {
		virtualMachine = JSVirtualMachine()
		javaScriptContext = KEContext(virtualMachine: virtualMachine)
		setupContext()
	}
	
	private func setupContext() {
		javaScriptContext.exceptionHandler = { context, exception in
			if let jscont = context as? KEContext {
				jscont.addErrorMessage(exception.description) ;
				return
			}
			NSLog("Internal error \(exception)")
		}

	}
	
	public func addGlobalNumber(name: NSString, value: NSNumber){
		javaScriptContext.setObject(value, forKeyedSubscript:name)
	}
	
	public func addGlobalString(name: NSString, value: NSString){
		javaScriptContext.setObject(value, forKeyedSubscript:name)
	}
	
	public func addGlobalArray(name: NSString, value: NSArray){
		javaScriptContext.setObject(value, forKeyedSubscript:name)
	}
	
	public func addGlobalObject(name: NSString, value: NSObject){
		javaScriptContext.setObject(value, forKeyedSubscript:name)
	}
	
	public func evaluate(script : String) -> (errors: Array<NSError>?, value: JSValue?){
		let retval = javaScriptContext.evaluateScript(script)
		let errcnt = javaScriptContext.runtimeErrors().count ;
		if(errcnt == 0){
			return (nil, retval)
		} else {
			return (javaScriptContext.runtimeErrors(), nil) ;
		}
	}
	
	public func call(funcname : String, arguments: Array<AnyObject>) -> (errors: Array<NSError>?, value: JSValue?){
		let jsfunc : JSValue = javaScriptContext.objectForKeyedSubscript(funcname)
		let retval = jsfunc.callWithArguments(arguments)
		let errcnt = javaScriptContext.runtimeErrors().count ;
		if(errcnt == 0){
			return (nil, retval)
		} else {
			return (javaScriptContext.runtimeErrors(), nil) ;
		}
	}
}

/*


@implementation KEEngine

	- (JSValue *) callFunc: (NSString *) funcname withArguments: (NSArray *) argv errors: (NSArray **) errors
{
	JSValue * funcref = [javaScriptContext objectForKeyedSubscript: funcname] ;
	JSValue * result ;
	if(funcref){
		result = [funcref callWithArguments: argv] ;
	} else {
		NSString * errmsg = [NSString stringWithFormat: @"Function \"%@\" is not found", funcname] ;
		[javaScriptContext addErrorMessage: errmsg] ;
		result = nil ;
	}
	*errors = [javaScriptContext copyRuntimeErrors] ;
	return result ;
}

@end
*/
