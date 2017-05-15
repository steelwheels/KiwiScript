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

public func testError() -> Bool
{
	var result = true
	let vm = JSVirtualMachine()
	let context = KEContext(virtualMachine: vm)
	
	print("*** Script1")
	let script1 = "function hoge" ;
	result = testScript(context: context, script: script1) && result
	
	print("*** Script2")
	let script2 = "function hoge(a, b){ return a hoge; }" ;
	result = testScript(context: context, script: script2) && result
	
	return true
}

private func testScript(context ctxt: KEContext, script scr: String) -> Bool
{
	var testResult = false
	let (resultp, errorsp) = KEEngine.runScript(context: ctxt, script: scr)
	if let errors = errorsp {
		for error in errors {
			print("ERROR: \(error)")
		}
	} else {
		if let result = resultp {
			print("RESULT: \(result)")
			testResult = true
		} else {
			fatalError("can not happen")
		}
	}
	return testResult
}
