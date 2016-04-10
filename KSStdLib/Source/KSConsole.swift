/**
 * @file	KSConsole.swift
 * @brief	Define KSConsole library class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation
import JavaScriptCore
import Canary

@objc protocol KSConsoleOperating : JSExport {
	func put(value : JSValue)
}

@objc public class KSConsole : NSObject, KSConsoleOperating
{
	public var mConsole : CNConsole? = nil
	
	public override init(){
		super.init()
	}
	
	public class func rootObjectName() -> String {
		return "console"
	}
	
	public func registerToContext(context : JSContext){
		context.setObject(self, forKeyedSubscript: KSConsole.rootObjectName())
	}
	
	public class func setToContext(context: JSContext, console newcons: CNConsole){
		if let jsvalue = context.objectForKeyedSubscript(KSConsole.rootObjectName()) {
			if let console = jsvalue.toObject() as? KSConsole {
				console.mConsole = newcons
			}
		}
	}
	
	public class func getFromContext(context: JSContext) -> CNConsole? {
		if let jsvalue = context.objectForKeyedSubscript(KSConsole.rootObjectName()) {
			if let console = jsvalue.toObject() as? KSConsole {
				return console.mConsole
			}
		}
		return nil
	}
	
	public func put(value : JSValue){
		if let console = mConsole {
			let valstr  = KSValueDescription.description(value)
			console.print(string: valstr)
		}
	}
}
