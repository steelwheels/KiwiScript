/**
 * @file	KSConsole.swift
 * @brief	Define KSConsole library class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Canary
import Foundation
import JavaScriptCore


@objc protocol KSConsoleOperating : JSExport {
	func put(_ value: JSValue)
}

@objc public class KSConsole : NSObject, KSConsoleOperating
{
	private var mConsole : CNConsole
	
	public init(console cons: CNConsole){
		mConsole = cons
		super.init()
	}
	
	public class func rootObjectName() -> NSString {
		return "console"
	}
	
	public func registerToContext(context ctxt: JSContext){
		ctxt.setObject(self, forKeyedSubscript: KSConsole.rootObjectName())
	}
	
	public func put(_ val: JSValue){
		mConsole.print(string: val.description + "\n")
	}
}
