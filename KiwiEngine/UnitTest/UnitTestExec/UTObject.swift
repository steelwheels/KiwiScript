/**
 * @file		UTObject.swift
 * @brief	Unit test for KiwiEngine framework
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Canary
import Foundation
import JavaScriptCore
import KiwiEngine

public func testObject(console cons: CNConsole) -> Bool
{
	let vm = JSVirtualMachine()
	let context = KEContext(virtualMachine: vm!)
	var testResult = false
	let newobj = UTObjectBridge()
	let newval = context.allocateObjectValue(object: newobj)
	let script =   "function test(object){"
		+ "  var tmp ;"
		+ "  tmp = object.angle() + 1.1 ;"
		+ "  object.setAngle(tmp) ; "
		+ "  return object.angle() ; "
		+ "}"
	cons.print(string: "*** context.runScript\n")
	context.runScript(script: script, exceptionHandler: {
		(_ result: KEExecutionResult) -> Void in
		testResult = finalizeHandler(result: result, console: console)
	})
	cons.print(string: "*** context.callFunction\n")
	context.callFunction(functionName: "test", arguments: [newval], exceptionHandler: {
		(_ result: KEExecutionResult) -> Void in
		testResult = finalizeHandler(result: result, console: console)
	})
	return testResult
}

private func finalizeHandler(result res: KEExecutionResult, console cons: CNConsole) -> Bool {
	var testResult = false
	switch res {
	case .Exception(_, let message):
		cons.print(string: "Exception: \(message)\n")
	case .Finished(_, let value):
		let message: String
		if let v = value {
			message = v.toString()
			testResult = true
		} else {
			message = "<none>"
		}
		cons.print(string: "Finished: \(message)\n")
	}
	return testResult
}

@objc protocol UTObjectBridging : JSExport {
	func angle() -> Double
	func setAngle(_ value : Double)
}

@objc public class UTObjectBridge : NSObject, UTObjectBridging
{
	var mAngle : Double

	public override init(){
		mAngle = 1.2
		super.init()
	}

	public func angle() -> Double {
		return mAngle
	}

	public func setAngle(_ value: Double) {
		mAngle = value
	}
}


