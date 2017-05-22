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
	context.evaluateScript("console.put(\"Hello, world!!\");")
	return true
}
