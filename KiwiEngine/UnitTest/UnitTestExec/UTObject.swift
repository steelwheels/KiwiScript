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
	let vm = JSVirtualMachine()
	let context = KEContext(virtualMachine: vm)
	let newobj = UTObjectBridge()
	let objval = context.allocateObjectValue(object: newobj)
	
	let script =   "function test(object){"
		     + "  var tmp ;"
		     + "  tmp = object.angle() + 1.1 ;"
		     + "  object.setAngle(tmp); "
		     + "}"
	runScript(context: context, script: script)
	
	let (_, errorsp) = KEEngine.callFunction(context: context, functionName: "test", arguments: [objval])
	if let errors = errorsp {
		print("Failed to call function")
		for error in errors {
			print("\(error)")
		}
		return false
	}
	
	print("RESULT: newangle = \(newobj.angle())")
	
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

private func runScript(context: KEContext, script : String)
{
	let (resultp, errorsp) = KEEngine.runScript(context: context, script: script)
	if let errors = errorsp {
		print("RunScript -> NG")
		for error in errors {
			print("\(error) ")
		}
	} else {
		if let result = resultp {
			print("RunScriot -> OK (\(result))")
		} else {
			fatalError("can not happen")
		}
	}
}

