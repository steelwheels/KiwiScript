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
	var mConsole : CNConsole
	var mDumper  : CNTextDumper
	
	public init(console : CNConsole){
		mConsole = console
		mDumper  = CNTextDumper()
		super.init()
	}
	
	public class func rootObjectName() -> String {
		return "console"
	}
	
	public func registerToContext(context : JSContext){
		context.setObject(self, forKeyedSubscript: KSConsole.rootObjectName())
	}
	
	public func put(value : JSValue){
		let encoder = KSJsonEncoder()
		let text    = encoder.encodeValue(value)
		mDumper.dumpToConsole(mConsole, text: text)
	}
}
