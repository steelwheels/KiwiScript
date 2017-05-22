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
	public var mConsole : CNConsole? = nil
	
	public override init(){
		super.init()
	}
	
	public class func rootObjectName() -> NSString {
		return "console"
	}
	
	public func registerToContext(context ctxt: JSContext){
		ctxt.setObject(self, forKeyedSubscript: KSConsole.rootObjectName())
	}
	
	public class func setToContext(context ctxt: JSContext, console cons: CNConsole){
		if let jsvalue = ctxt.objectForKeyedSubscript(KSConsole.rootObjectName()) {
			if let console = jsvalue.toObject() as? KSConsole {
				console.mConsole = cons
			}
		}
	}
	
	public class func getFromContext(context ctxt: JSContext) -> CNConsole? {
		if let jsvalue = ctxt.objectForKeyedSubscript(KSConsole.rootObjectName()) {
			if let console = jsvalue.toObject() as? KSConsole {
				return console.mConsole
			}
		}
		return nil
	}
	
	public func put(_ val: JSValue){
		if let console = mConsole {
			let text = KSValueDescription(value: val)
			text.print(console: console)
		}
	}
}
