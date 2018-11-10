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
	var result = true

	let config   = KEConfig()
	config.doVerbose = true

	let context  = KEContext(virtualMachine: JSVirtualMachine())
	context.exceptionCallback = {
		(_ exception: KEException) -> Void in
		cons.error(string: exception.description + "\n")
	}

	console.print(string: "* Setup compiler\n")
	let compiler = KECompiler(console: cons, config: config)
	if compiler.compile(context: context) {
		cons.print(string: "Compile: OK\n")

		/* Test "_exec" */
		let script0  = "_exec_cancelable(function(){ return 0 ; }) ;\n"
		let compres0 = compiler.compile(context: context, statement: script0)
		let resstr0  = valueToString(value: compres0)
		cons.print(string: "* result0 = \(resstr0)\n")
		let result0 = (resstr0 == "0")

		/* Test "_cancel" */
		let script1  = "_exec_cancelable(function(){ _cancel(1) ; return 0 ;}) ;\n"
		let compres1 = compiler.compile(context: context, statement: script1)
		let resstr1  = valueToString(value: compres1)
		cons.print(string: "* result1 = \(resstr1)\n")
		let result1 = (resstr1 == "1")

		result = result0 && result1
	} else {
		cons.print(string: "Compile: NG\n")
		result = false
	}
	return result
}


private func valueToString(value val: JSValue?) -> String
{
	if let v = val {
		return v.description
	} else {
		return "nil"
	}
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
