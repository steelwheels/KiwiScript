/**
 * @file	UTDebug.swift
 * @brief	Unit test for built-in methods for debugging
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation
import JavaScriptCore
import KSStdLib
import Canary

public func testDebug() -> Bool
{
	let context = UTSetup.setup()

	let stmt0 =	"var obj = {a:0.0, b:\"\"} ;" +
			"debug.dumpProperties(obj) ;"
	context.evaluateScript(stmt0)
	return true
}
