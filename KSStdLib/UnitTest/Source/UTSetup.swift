/**
 * @file	UTSetup.swift
 * @brief	Setup function for KSStdLib
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import KSStdLib
import Canary
import JavaScriptCore
import Foundation

public class UTSetup
{
	public class func setup() -> JSContext
	{
		let vm = JSVirtualMachine()
		if let context = JSContext(virtualMachine: vm) {
			context.exceptionHandler = { (context, exception) in
				var desc: String
				if let e = exception {
					desc = e.toString()
				} else {
					desc = "nil"
				}
				print("JavaScript Error: \(desc)")
			}
			let outcons = CNFileConsole(file: CNTextFile.stdout)
			let errcons = CNFileConsole(file: CNTextFile.stderr)
			KSStdLib.setup(context: context, stdout: outcons, stderr: errcons)
			return context
		}
		fatalError("Interval error")
	}
}
