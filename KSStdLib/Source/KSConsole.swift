/**
 * @file	KSConsole.swift
 * @brief	Define KSConsole library class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation
import JavaScriptCore

@objc protocol KSConsoleOperating : JSExport {
	func put(value : JSValue)
}

@objc public class KSConsole : NSObject, KSConsoleOperating {
	public class func rootObjectName() -> String {
		return "console"
	}
	
	public class func register(context : JSContext){
		context.setObject(KSConsole.self, forKeyedSubscript: rootObjectName())

	}
	
	public func put(value : JSValue){
		let encoder = KSJsonEncoder()
		let buf = encoder.encode(value)
		buf.dump()
	}
}
