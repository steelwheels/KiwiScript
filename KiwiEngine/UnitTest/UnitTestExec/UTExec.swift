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

/*
public func testObject(console cons: CNConsole) -> Bool
{

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

	let _ = context.runScript(script: script)
	cons.print(string: "*** context.callFunction\n")
	let _ = context.callFunction(functionName: "test", arguments: [newval!])

	return testResult
}

private func finalizeHandler(result res: KEException, console cons: CNConsole) -> Bool {
	var testResult = false
	cons.print(string: res.description + "\n")
	switch res {
	case .finished(_, let value):
		if let _ = value {
			testResult = true
		}
	default:
		break
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

*/

