//
//  UTSerialize.swift
//  KiwiEngine
//
//  Created by Tomoo Hamada on 2017/06/25.
//  Copyright © 2017年 Steel Wheels Project. All rights reserved.
//

import KiwiEngine
import Canary
import JavaScriptCore
import Foundation

public func testSerialize(console cons: CNConsole) -> Bool
{
	let vm      = JSVirtualMachine()
	let context = KEContext(virtualMachine: vm)

	console.print(string: "***** Scalar Boolean\n")
	let script0 = "v0 = true ;"
	let result0 = UTExecute(context: context, console: console, script: script0)

	console.print(string: "***** Scalar Int\n")
	let scripti1 = "i1 = 123"
	let resulti1 = UTExecute(context: context, console: console, script: scripti1)

	console.print(string: "***** Scalar Double\n")
	let script1 = "v1 = 1.23"
	let result1 = UTExecute(context: context, console: console, script: script1)

	console.print(string: "***** Array of strings\n")
	let script2 = "v2 = [\"hello\", \"world\"] ;"
	let result2 = UTExecute(context: context, console: console, script: script2)

	console.print(string: "***** Array of booleans\n")
	let script3 = "v3 = [true, false] ;"
	let result3 = UTExecute(context: context, console: console, script: script3)

	console.print(string: "**** Dictionary\n")
	let scriptd1 =   "d1i = new Object() ; "
		      + "d1i.width  = 10.1 ; "
		      + "d1i.height = 11.3 ; "
		      + "d1 = d1i ; "
	let resultd1 = UTExecute(context: context, console: console, script: scriptd1)

	console.print(string: "**** Dictionary(2)\n")
	let scriptd2 =   "d2i = new Object() ; "
		      + "d2i.width  = \"a\" ; "
		      + "d2i.height = \"f\" ; "
		      + "d2 = d2i ; "
	let resultd2 = UTExecute(context: context, console: console, script: scriptd2)

	console.print(string: "**** Dictionary(3)\n")
	let scriptd3 =    "d3i = new Object() ; "
		        + "d3i.ensble  = true ; "
			+ "d3i.visible = false ; "
			+ "d3 = d3i ; "
	let resultd3 = UTExecute(context: context, console: console, script: scriptd3)

	return result0 && result1 && resulti1 && result2 && result3 && resultd1 && resultd2 && resultd3
}

public func UTExecute(context ctxt: KEContext, console cons: CNConsole, script scr: String) -> Bool
{
	let (retval, errors) = KEEngine.runScript(context: ctxt, script: scr)
	if let errors = errors {
		cons.print(string: " -> Exec result: NG\n")
		for err in errors {
			cons.print(string: "  -> Error: \(err)\n")
		}
		return false
	} else {
		cons.print(string: " -> Exec result: OK\n")
		return serialize(value: retval!, console: cons)
	}
}

private func serialize(value val: JSValue, console cons: CNConsole) -> Bool
{
	let type = KESerializeType(value: val)
	console.print(string: "TYPE: \(type)\nDATA: ")

	if let text = KESerializeValue(value: val) {
		text.print(console: cons)
		return true
	} else {
		console.print(string: "Could not serialize")
		return false
	}
}