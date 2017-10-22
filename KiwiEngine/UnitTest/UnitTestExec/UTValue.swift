/**
 * @file	UTValue.swift
 * @brief	Extension of CNValue
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import KiwiEngine
import Canary
import JavaScriptCore
import Foundation

public func testValue(console cons: CNConsole) -> Bool
{
	let vm = JSVirtualMachine()
	let context = KEContext(virtualMachine: vm)

	let elm0 = CNValue(floatValue: 10.0)
	let elm1 = CNValue(floatValue: 11.1)
	let srcvals = [
		CNValue(booleanValue: true),
		CNValue(characterValue: "c"),
		CNValue(intValue: -1234),
		CNValue(uIntValue: 1234),
		CNValue(floatValue: 12.34),
		CNValue(doubleValue: -43.21),
		CNValue(stringValue: "Hello, world"),
		CNValue(arrayValue: [elm0, elm1]),
		//CNValue(setValue: [elm0, elm1]),
		CNValue(dictionaryValue: ["a":elm0, "b":elm1])
	]
	var result: Bool = true
	for srcval in srcvals {
		let r0 = convert(value: srcval, context: context, console: cons)
		result = result && r0
	}
	return result
}

private func convert(value val: CNValue, context ctxt: KEContext, console cons: CNConsole) -> Bool
{
	let jsval = val.toJSValue(context: ctxt)
	cons.print(string: "convert: \(val.description) -> \(jsval)\n")
	return true
}

