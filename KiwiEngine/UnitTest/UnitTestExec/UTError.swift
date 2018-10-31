/**
 * @file	UTStdLib.swift
 * @brief	Unit test for exception handler
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation
import KiwiEngine
import CoconutData
import JavaScriptCore

public func testError(console cons: CNConsole) -> Bool
{
	var result = true
	let vm = JSVirtualMachine()
	let context = KEContext(virtualMachine: vm!)

	console.print(string: "*** Script1\n")
	let script1 = "function hoge" ;
	result = testScript(console: cons, context: context, script: script1) && result

	console.print(string: "*** Script2\n")
	let script2 = "function hoge(a, b){ return a hoge; }" ;
	result = testScript(console: cons, context: context, script: script2) && result

	return result
}

private func testScript(console cons: CNConsole, context ctxt: KEContext, script scr: String) -> Bool
{
	var testResult = false
	ctxt.exceptionCallback = {
		(_ result: KEException) -> Void in
		console.print(string: result.description + "\n")
		testResult = true /* Error is required */
	}
	let _ = ctxt.evaluateScript(scr)
	return testResult
}
