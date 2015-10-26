/**
 * @file	KSStdLib.swift
 * @brief	Function to register the KSStdLib library into the user program
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation
import JavaScriptCore
import Canary

public func KSSetupStdLib(context : JSContext, console : CNConsole)
{
	let consolelib = KSConsole(console: console)
	consolelib.registerToContext(context)
	
	let mathlib = KSMath(context: context)
	mathlib.registerToContext(context)
}

