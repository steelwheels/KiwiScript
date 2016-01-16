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
	
	public init(console : CNConsole){
		mConsole = console
		super.init()
	}
	
	public class func rootObjectName() -> String {
		return "console"
	}
	
	public func registerToContext(context : JSContext){
		context.setObject(self, forKeyedSubscript: KSConsole.rootObjectName())
	}
	
	public func put(value : JSValue){
		let encval = KSValueCoder.encode(value)
		let (encstr, encerr) = CNJSONFile.serializeToString(encval)
		if let error = encerr {
			let errmsg = error.toString()
			mConsole.printLine(errmsg)
		} else if let str = encstr {
			mConsole.printLine(str)
		} else {
			fatalError("Invalid return value")
		}
	}
}