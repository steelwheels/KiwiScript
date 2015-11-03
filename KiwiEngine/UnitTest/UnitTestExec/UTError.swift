/**
 * @file	UTStdLib.swift
 * @brief	Unit test for exception handler
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation
import KiwiEngine
import Canary

public func testError() -> Bool
{
	var result = true
	let engine = KEEngine()
	
	print("*** Script1")
	let script1 = "function hoge" ;
	result = testScript(engine, script: script1) && result
	
	print("*** Script2")
	let script2 = "function hoge(a, b){ return a hoge; }" ;
	result = testScript(engine, script: script2) && result
	
	return true
}

private func testScript(engine : KEEngine, script : String) -> Bool
{
	var testResult = false
	let (resultp, errorsp) = engine.runScript(script)
	if let errors = errorsp {
		for error in errors {
			let str = error.toString()
			print("ERROR: \(str)")
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
