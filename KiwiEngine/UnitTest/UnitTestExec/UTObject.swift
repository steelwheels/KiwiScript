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
	let context = KEContext(virtualMachine: vm)
	let newobj = UTObjectBridge()
	let objval = context.allocateObjectValue(object: newobj)

	let script =   "function test(object){"
		     + "  var tmp ;"
		     + "  tmp = object.angle() + 1.1 ;"
		     + "  object.setAngle(tmp); "
		     + "}"
	runScript(console: cons, context: context, script: script)

	let (_, errorsp) = KEEngine.callFunction(context: context, functionName: "test", arguments: [objval])
	if let errors = errorsp {
		console.print(string: "Failed to call function\n")
		for error in errors {
			console.print(string: "\(error)\n")
		}
		return false
	}

	console.print(string: "RESULT: newangle = \(newobj.angle())\n")

	return true
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

private func runScript(console cons: CNConsole, context: KEContext, script : String)
{
	let (resultp, errorsp) = KEEngine.runScript(context: context, script: script)
	if let errors = errorsp {
		cons.print(string: "RunScript -> NG\n")
		for error in errors {
			cons.print(string: "\(error) ")
		}
	} else {
		if let result = resultp {
			cons.print(string: "RunScriot -> OK (\(result))\n")
		} else {
			fatalError("can not happen")
		}
	}
}

