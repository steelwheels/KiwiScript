/**
 * @file	UTStdLib.swift
 * @brief	Unit test for exception handler
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation
import KiwiEngine
import Canary
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

	return true
}

private func testScript(console cons: CNConsole, context ctxt: KEContext, script scr: String) -> Bool
{
	var testResult = false

	ctxt.runScript(script: scr, exceptionHandler: {
		(_ result: KEExecutionResult) -> Void in
		switch result {
		case .Exception(_, let message):
			console.print(string: "Exception: \(message)\n")
		case .Finished(_, let value):
			let message: String
			if let v = value {
				message = v.toString()
				testResult = true
			} else {
				message = "<none>"
			}
			console.print(string: "Finished: \(message)\n")
		}
	})
	return testResult
}
