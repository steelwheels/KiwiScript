/**
 * @file	KSStdLib.swift
 * @brief	Function to register the KSStdLib library into the user program
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation
import JavaScriptCore
import Canary

public class KSStdLib {
	public class func setup(context: JSContext){
		let consolelib = KSConsole()
		consolelib.registerToContext(context)
		
		let mathlib = KSMath(context: context)
		mathlib.registerToContext(context)
	}
	
	public class func console(context: JSContext) -> CNConsole? {
		return KSConsole.getFromContext(context)
	}
	
	public class func setConsole(context: JSContext, console: CNConsole){
		KSConsole.setToContext(context, console: console)
	}
}



