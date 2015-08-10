/**
 * @file	KLConsole.swift
 * @brief	Extend KLConsole class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation
import JavaScriptCore

public class KLConsole : NSObject
{
	override init(){
		super.init()
	}
	
	public func putJSValue(str : JSValue){
		NSLog(str.description) ;
	}
}

