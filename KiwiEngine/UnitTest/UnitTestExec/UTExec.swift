/**
 * @file		UTObject.swift
 * @brief	Unit test for KiwiEngine framework
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import CoconutData
import Foundation
import JavaScriptCore
import KiwiEngine

public func testExec(console cons: CNConsole) -> Bool
{
	let result = true

	//let config   = KEConfig(kind: .Terminal, doStrict: true, doVerbose: true)

	let context  = KEContext(virtualMachine: JSVirtualMachine())
	context.exceptionCallback = {
		(_ exception: KEException) -> Void in
		cons.error(string: exception.description + "\n")
	}

	return result
}


private func valueToInt(value val: JSValue?) -> Int32?
{
	if let v = val {
		if v.isNumber {
			return v.toInt32()
		}
	}
	return nil
}


