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
	var mConsole : CNRedirectConsole
	
	public init(console : CNRedirectConsole){
		mConsole = console
		super.init()
	}
	
	public class func rootObjectName() -> String {
		return "console"
	}
	
	public func registerToContext(context : JSContext){
		context.setObject(self, forKeyedSubscript: KSConsole.rootObjectName())
	}
	
	public class func consoleInContext(context: JSContext) -> CNRedirectConsole? {
		if let jsvalue = context.objectForKeyedSubscript(KSConsole.rootObjectName()) {
			if let console = jsvalue.toObject() as? KSConsole {
				return console.mConsole
			}
		}
		return nil
	}
	
	public func put(value : JSValue){
		let valstr  = KSValueDescription.description(value)
		mConsole.print(string: valstr)
	}
}
