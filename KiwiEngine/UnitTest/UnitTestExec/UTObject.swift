/**
* @file		UTObject.swift
* @brief	Unit test for KSStdLib framework
* @par Copyright
*   Copyright (C) 2015 Steel Wheels Project
*/

import Foundation
import JavaScriptCore
import KiwiEngine

public func testObject() -> Bool
{
	let engine = KEEngine()
	let newobj = UTObjectBridge()
	let objval = engine.context().allocateObjectValue(newobj)
	
	let script =   "function test(object){"
		     + "  var tmp ;"
		     + "  tmp = object.angle() + 1.1 ;"
		     + "  object.setAngle(tmp); "
		     + "}"
	runScript(engine, script: script)
	
	let (_, errorsp) = engine.callFunction("test", arguments: [objval])
	if let errors = errorsp {
		print("Failed to call function")
		for error in errors {
			print("\(error.toString())")
		}
		return false
	}
	
	print("RESULT: newangle = \(newobj.angle())")
	
	return true
}

@objc protocol UTObjectBridging : JSExport {
	func angle() -> Double
	func setAngle(value : Double)
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
	
	public func setAngle(value: Double) {
		mAngle = value
	}
}

private func runScript(engine : KEEngine, script : String)
{
	let (result, errors) = engine.runScript(script)
	if let resval = result {
		print("RunScriot -> OK (\(resval))")
	} else {
		print("RunScript -> NG")
		for error in errors {
			print("\(error.toString()) ")
		}
	}
}

