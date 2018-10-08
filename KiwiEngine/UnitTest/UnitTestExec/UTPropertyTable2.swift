/**
 * @file	UTPropertyTable2.swift
 * @brief	Unit test for KEPropertyTable2 class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

@objc private protocol UTObjectProtocol: JSExport
{
	func set(_ name: String, _ value: JSValue)
	func get(_ name: String) -> JSValue
}

@objc private class UTObject: NSObject, UTObjectProtocol
{
	private var mName:		String
	private var mContext:		KEContext
	private var mConsole:		CNConsole
	private var mPropertyTable:	KEPropertyTable

	public init(name nm: String, context ctxt: KEContext, console cons: CNConsole){
		mName 		= nm
		mContext	= ctxt
		mConsole	= cons
		mPropertyTable	= KEPropertyTable(context: ctxt)
	}

	public func set(_ name: String, _ value: JSValue){
		mConsole.print(string: "[\(mName)] set(\(name), \(value.description))\n")
		mPropertyTable.set(name, value)

	}

	public func get(_ name: String) -> JSValue {
		let value = mPropertyTable.get(name)
		//mConsole.print(string: "[\(mName)] get(\(name)) -> \(value.description)\n")
		return value
	}

	public func setObject(_ name: String, _ object: JSExport){
		if let value = JSValue(object: object, in: mContext) {
			mPropertyTable.set(name, value)
		}
	}
}

public func testPropertyTable2(console cons: CNConsole) -> Bool
{
	let vm = JSVirtualMachine()
	let context = KEContext(virtualMachine: vm!)

	let obja = UTObject(name: "objA", context: context, console: cons)
	let objb = UTObject(name: "objB", context: context, console: cons)
	obja.setObject("obj_b", objb)

	context.set(name: "obj_a", object: obja)
	
	let script =   "obj_a.set(\"prop_a\", 10) ;"
		     + "obj_a.get(\"obj_b\").set(\"prop_b\", \"Hello\") ;"

	var testResult:  Bool	= false
	var scrdone: Bool	= false

	context.exceptionCallback = {
		(_ result: KEException) -> Void in
		testResult = finalizeHandler(result: result, console: console)
		scrdone    = true
	}

	context.runScript(script: script)

	while !scrdone {

	}

	return testResult
}

private func finalizeHandler(result res: KEException, console cons: CNConsole) -> Bool {
	var testResult = false
	cons.print(string: res.description + "\n")
	switch res {
	case .Terminated(_, _), .CompileError(_), .Runtime(_), .Exit(_):
		break
	case .Evaluated(_, let value):
		if let _ = value {
			testResult = true
		}
	}
	return testResult
}

