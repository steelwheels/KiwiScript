/**
 * @file	UTValue.swift
 * @brief	Unit test for KiwiEngine framework
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import KiwiEngine
import Canary
import JavaScriptCore
import Foundation

public func testPropertyTable(console cons: CNConsole) -> Bool
{
	let vm      = JSVirtualMachine()
	let context = KEContext(virtualMachine: vm)
	let table   = KEPropertyTable(context: context)

	var result = true

	console.print(string: " TEST: Bool : ")
	table.setBooleanValue(identifier: "b0", value: false)
	if let retval = table.booleanValue(identifier: "b0") {
		if retval {
			console.print(string: "Unexpected result\n")
			result = false
		} else {
			console.print(string: "OK\n")
		}
	} else {
		console.print(string: "No return value\n")
		result = false
	}

	console.print(string: " TEST: Int : ")
	table.setIntValue(identifier: "i0", value: -1234)
	if let retval = table.intValue(identifier: "i0") {
		if retval == -1234 {
			console.print(string: "OK\n")
		} else {
			console.print(string: "Unexpected result: \(retval)\n")
			result = false
		}
	} else {
		console.print(string: "No return value\n")
		result = false
	}

	console.print(string: " TEST: UInt : ")
	table.setUIntValue(identifier: "u0", value: 1234)
	if let retval = table.uIntValue(identifier: "u0") {
		if retval == 1234 {
			console.print(string: "OK\n")
		} else {
			console.print(string: "Unexpected result: \(retval)\n")
			result = false
		}
	} else {
		console.print(string: "No return value\n")
		result = false
	}

	console.print(string: " TEST: Double : ")
	table.setDoubleValue(identifier: "d0", value: 12.34)
	if let retval = table.doubleValue(identifier: "d0") {
		if retval == 12.34 {
			console.print(string: "OK\n")
		} else {
			console.print(string: "Unexpected result: \(retval)\n")
			result = false
		}
	} else {
		console.print(string: "No return value\n")
		result = false
	}

	console.print(string: " TEST: String : ")
	table.setStringValue(identifier: "s0", value: "hello")
	if let retval = table.stringValue(identifier: "s0") {
		if retval == "hello" {
			console.print(string: "OK\n")
		} else {
			console.print(string: "Unexpected result: \(retval)\n")
			result = false
		}
	} else {
		console.print(string: "No return value\n")
		result = false
	}

	console.print(string: " TEST: Array : ")
	let elm0 = NSNumber(value: 0)
	let elm1 = NSNumber(value: 1)
	table.setArrayValue(identifier: "a0", value: [elm0, elm1])
	if let retval = table.arrayValue(identifier: "a0") {
		let retval0 = retval[0] as! NSNumber
		let retval1 = retval[1] as! NSNumber
		if retval0.int32Value == 0 && retval1.int32Value == 1 {
			console.print(string: "OK\n")
		} else {
			console.print(string: "Unexpected result: \(retval)\n")
			result = false
		}
	} else {
		console.print(string: "No return value\n")
		result = false
	}

	console.print(string: " TEST: Callback : ")
	let callback = "var callback = function() { return 1 + 2 ; }"
	context.evaluateScript(callback)
	if context.runtimeErrors().count == 0 {
		if let funcref = context.objectForKeyedSubscript("callback") {
			table.setCallback(identifier: "callback", function: funcref)
			if let retval = table.callback(identifier: "callback") {
				if let result = retval.call(withArguments: []) {
					console.print(string: "OK result = \(result) \n")
				} else {
					console.print(string: "Failed to call function\n")
					result = false
				}
			} else {
				console.print(string: "No return value\n")
				result = false
			}
		} else {
			console.print(string: "Error: No callback object")
			result = false
		}
	} else {
		for message in context.runtimeErrors() {
			console.print(string: "Error: \(message)\n")
		}
		result = false
	}

	return result
}

/*
public func testValue(console cons: CNConsole) -> Bool
{


	struct TestObject {
		var	name:	String
		var	value:	JSValue
	}

	evaluate(context: context, script: "var obj0 = {a:10, b:\"hello\"} ;\n")
	let obj0 = context.objectForKeyedSubscript("obj0")

	evaluate(context: context, script: "var func0 = function(){ return 1+1 ; } ;")
	let func0 = context.objectForKeyedSubscript("func0")

	let testobjs: Array<TestObject> = [
		TestObject(name: "bool", value: JSValue(bool: true, in: context)),
		TestObject(name: "double", value: JSValue(double: 12.3, in: context)),
		TestObject(name: "int32", value: JSValue(int32: -123, in: context)),
		TestObject(name: "uint32", value: JSValue(uInt32: 123, in: context)),
		TestObject(name: "Object", value: obj0!),
		TestObject(name: "Fnction", value: func0!)
	]

	for obj in testobjs {
		testValueType(message: obj.name, value: obj.value, console: console)
	}

	return true
}

private func evaluate(context ctxt: KEContext, script scr: String)
{
	console.print(string: "Evaluate script: \"\(scr)\"")
	let _    = ctxt.evaluateScript(scr)
	let errs = ctxt.runtimeErrors()
	if errs.count > 0 {
		for str in errs {
			console.print(string: "Error: \(str)")
		}
	}
}

private func testValueType(message msg: String, value val: JSValue, console cons: CNConsole)
{
	console.print(string: "\(msg): [kind] \(val.kind.description)\n")
}
*/
