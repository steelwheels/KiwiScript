/**
 * @file	UTMath.swift
 * @brief	Unit test for math
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation
import JavaScriptCore
import KSStdLib
import Canary

public func testMath() -> Bool
{
	if let context = JSContext() {
		let outcons = CNFileConsole(file: CNTextFile.stdout)
		let errcons = CNFileConsole(file: CNTextFile.stderr)

		KSStdLib.setup(context: context, stdout: outcons, stderr: errcons)

		context.exceptionHandler = { (context, value) in
			let desc: String
			if let v = value {
				desc = v.toString()
			} else {
				desc = "nil"
			}
			print("JavaScript Error: \(desc)")
		}
	
		context.evaluateScript(
			"console.put(\"PI = \" + Math.PI);"
				+ "console.put(\"sin(PI/2) = \" + Math.sin(Math.PI/2)) ;"
				+ "console.put(\"cos(PI/2) = \" + Math.cos(Math.PI/2)) ;"
		) ;
		return true
	} else {
		print("[Error] Can not allocate JSContext")
		return false
	}
}

