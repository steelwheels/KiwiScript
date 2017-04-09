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

public func testKSValueType() -> Bool {

	let console = CNTextConsole()

	if let context = JSContext() {

		print("*** var var0 = 1")
		executeScript(console: console, context: context, name:"var0", code:"var var0=1")
		print("*** var var1 = 1.23")
		executeScript(console: console, context: context, name:"var1", code:"var var1=1.23")
		print("*** var var2 = [\"A\" , \"B\" , \"C\" , 123 , 456 , true , false];")
		executeScript(console: console, context: context, name:"var2", code:"var var2 = [\"A\" , \"B\" , \"C\" , 123 , 456 , true , false];")
	
		return true
	} else {
		print("[Error] Can not allocate JSContext")
		return false
	}
}

private func executeScript(console cons: CNConsole, context ctxt: JSContext, name nm: String, code cd: String)
{
	ctxt.evaluateScript(cd)
	if let retval : JSValue = ctxt.objectForKeyedSubscript(nm) {
		let line = KSValueDescription.description(value: retval)
		cons.print(text: CNConsoleText(string: line))
	} else {
		print("11")
	}
}
