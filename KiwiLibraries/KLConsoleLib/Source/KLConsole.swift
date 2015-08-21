/**
 * @file	KLConsole.swift
 * @brief	Extend KLConsole class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation
import JavaScriptCore
import KiwiEngine

@objc protocol KLConsoleProtocol : JSExport
{
	func puts(str : String) ;
}

public class KLConsole : NSObject, KLConsoleProtocol
{
	override init(){
		super.init()
	}
	
	public func addToEngine(engine : KEEngine) {
		engine.addGlobalObject("console", value: self)
	}
	
	public func puts(str: String) {
		NSLog(str) ;
	}
	
	public func putErrors(errors: Array<NSError>){
		var message : String = ""
		for error : NSError in errors {
			message += error.toString() + "\n"
		}
		puts(message)
	}
	
	public func putJSValue(str : JSValue){
		puts(str.description) ;
	}
}

