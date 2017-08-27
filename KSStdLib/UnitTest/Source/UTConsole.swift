/**
 * @file	UTConsole.swift
 * @brief	Unit test for console
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import JavaScriptCore
import KSStdLib

public func testConsole() -> Bool
{
	let context = UTSetup.setup()
	context.evaluateScript("console.put(\"Hello, world!!\");\n")
	context.evaluateScript("console.fput(stdout, \"stdout: \" + stdout.toString());\n")
	context.evaluateScript("console.fput(stdout, \"\\n\");\n")
	context.evaluateScript("console.fput(stderr, \"stderr: \" + stderr.toString());\n")
	context.evaluateScript("console.fput(stderr, \"\\n\");\n")
	return true
}
