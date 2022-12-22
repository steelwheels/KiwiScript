/*
 * @file	UTNativeValue.swift
 * @brief	Test CNValue class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import KiwiLibrary
import KiwiEngine
import CoconutData
import Foundation

public func UTNativeValue(context ctxt: KEContext, console cons: CNConsole) -> Bool
{
	//let res0 = UTStructValue(console: cons)
	let res1 = UTSetValue(context: ctxt, console: cons)
	return res1 // && res1
}

/*
private func UTStructValue(console cons: CNConsole) -> Bool
{
	let strct0 = CNStruct(name: "UTStruct")
	let parama = CNValue.numberValue(NSNumber(floatLiteral: 1.2))
	let paramb = CNValue.stringValue("StringParam")
	strct0.setMember(name: "a", value: parama)
	strct0.setMember(name: "b", value: paramb)

	let desc = strct0.JSClassDefinition()
	cons.print(string: "*** Class definition ***\n\(desc)")

	return true
}
*/

private func UTSetValue(context ctxt: KEContext, console cons: CNConsole) -> Bool
{
	var result = true

	cons.print(string: "*** Test set-value\n")
	// allocate native
	let num1: CNValue = .numberValue(NSNumber(integerLiteral: 1))
	let num2: CNValue = .numberValue(NSNumber(integerLiteral: 2))
	let num3: CNValue = .numberValue(NSNumber(integerLiteral: 4))
	let sval: CNValue = .setValue([num1, num2, num3])
	cons.print(string: "source native set: \(sval.toScript().toStrings().joined(separator: "\n"))\n")

	// convert to script value
	let sconv = KLNativeValueToScriptValue(context: ctxt)
	let jval  = sconv.convert(value: sval)
	if jval.isSet {
		cons.print(string: "isSet ... OK\n")
	} else {
		cons.print(string: "isSet ... Error\n")
		result = false
	}

	// convert from script value
	if let rval = CNValueSet.fromJSValue(scriptValue: jval) {
		cons.print(string: "fromJSValue ... OK\n")
		cons.print(string: "reverted native set: \(rval.toScript().toStrings().joined(separator: "\n"))\n")
	} else {
		cons.print(string: "fromJSValue ... Error\n")
		result = false
	}
	return result
}

