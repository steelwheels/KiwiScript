/**
 * @file	KSStdLib.swift
 * @brief	Function to register the KSStdLib library into the user program
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation
import JavaScriptCore
import Canary

public class KSStdLib
{
	public class func setup(context ctxt: JSContext, stdout outcons: CNConsole, stderr errcons: CNConsole)
	{
		let consolelib = KSConsole(stdout: outcons, stderr: errcons)
		consolelib.registerToContext(context: ctxt)
		
		let mathlib = KSMath(context: ctxt)
		mathlib.registerToContext(context: ctxt)

		ctxt.evaluateScript(KSConsole.preCompileScript())
	}
}



