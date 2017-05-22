/**
 * @file	UTValueType.swift
 * @brief	Unit test for type of KSValue
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation
import JavaScriptCore
import Canary
import KSStdLib

public func testKSValueType(console cons: CNConsole) -> Bool {
	if let context = JSContext() {

		console.print(string: "*** var var0 = 1\n")
		executeScript(console: console, context: context, name:"var0", code:"var var0=1")
		console.print(string: "*** var var1 = 1.23\n")
		executeScript(console: console, context: context, name:"var1", code:"var var1=1.23")
		console.print(string: "*** var var2 = [\"A\" , \"B\" , \"C\" , 123 , 456 , true , false];\n")
		executeScript(console: console, context: context, name:"var2", code:"var var2 = [\"A\" , \"B\" , \"C\" , 123 , 456 , true , false];")

		return true
	} else {
		console.print(string: "[Error] Can not allocate JSContext\n")
		return false
	}
}

private func executeScript(console cons: CNConsole, context ctxt: JSContext, name nm: String, code cd: String)
{
	ctxt.evaluateScript(cd)
	if let retval : JSValue = ctxt.objectForKeyedSubscript(nm) {
		let text = KSValueDescription(value: retval)
		text.print(console: cons)
	} else {
		console.print(string: "11\n")
	}
}
