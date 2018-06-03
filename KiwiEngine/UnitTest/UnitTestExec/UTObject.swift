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

public func testObject(console cons: CNConsole) -> Bool
{
	let vm = JSVirtualMachine()
	let context = KEContext(virtualMachine: vm!)
	var testResult = false
	let newobj = UTObjectBridge()
	let newval = JSValue(object: newobj, in: context)
	let script =   "function test(object){"
		+ "  var tmp ;"
		+ "  tmp = object.angle() + 1.1 ;"
		+ "  object.setAngle(tmp) ; "
		+ "  return object.angle() ; "
		+ "}"
	cons.print(string: "*** context.runScript\n")

	context.exceptionCallback = {
		(_ result: KEException) -> Void in
		testResult = finalizeHandler(result: result, console: console)
	}

	context.runScript(script: script)
	cons.print(string: "*** context.callFunction\n")
	context.callFunction(functionName: "test", arguments: [newval!])

	return testResult
}

private func finalizeHandler(result res: KEException, console cons: CNConsole) -> Bool {
	var testResult = false
	switch res {
	case .Terminated(_, let message):
		cons.print(string: "Terminated: \(message)\n")
	case .Evaluated(_, let value):
		let message: String
		if let v = value {
			message = v.toString()
			testResult = true
		} else {
			message = "<none>"
		}
		cons.print(string: "Evaluated: \(message)\n")
	case .CompileError(let message):
		cons.print(string: "Compile error: \(message)\n")
	case .Exit(let code):
		cons.print(string: "Exit: \(code)\n")
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


