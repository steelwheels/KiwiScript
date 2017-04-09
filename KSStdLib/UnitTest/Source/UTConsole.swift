/**
 * @file	UTConsole.swift
 * @brief	Unit test for console
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation
import JavaScriptCore
import KSStdLib
import Canary

public func testConsole() -> Bool
{
	if let context = JSContext() {
		KSStdLib.setup(context: context)
		KSStdLib.setupRuntime(context: context, console: CNTextConsole())
	
		context.exceptionHandler = { (context, exception) in
			var desc: String
			if let e = exception {
				desc = e.toString()
			} else {
				desc = "nil"
			}
			print("JavaScript Error: \(desc)")
		}
	
		context.evaluateScript("console.put(\"Hello, world!!\");")
		return true
	} else {
		print("[Error] Can not allocate JSContext")
		return false
	}
}
