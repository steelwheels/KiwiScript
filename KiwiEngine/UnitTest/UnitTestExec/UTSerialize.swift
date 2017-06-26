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
	let result0 = execute(context: context, console: console, script: script0)

	console.print(string: "***** Scalar Double\n")
	let script1 = "v1 = 1.23"
	let result1 = execute(context: context, console: console, script: script1)

	console.print(string: "***** Array of strings\n")
	let script2 = "v2 = [\"hello\", \"world\"] ;"
	let result2 = execute(context: context, console: console, script: script2)

	console.print(string: "**** Dictionary\n")
	let script3 =   "v3 = new Object() ; "
		      + "v3.width  = 10.1 ; "
		      + "v3.height = 11.3 ; "
		      + "v4 = v3 ; "
	let result3 = execute(context: context, console: console, script: script3)

	console.print(string: "**** Dictionary(2)\n")
	let script4 =   "v4 = new Object() ; "
		      + "v4.width  = \"a\" ; "
		      + "v4.height = \"f\" ; "
		      + "v5 = v4 ; "
	let result4 = execute(context: context, console: console, script: script4)

	return result0 && result1 && result2 && result3 && result4
}

private func execute(context ctxt: KEContext, console cons: CNConsole, script scr: String) -> Bool
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
	if let text = KESerializeValue(value: val) {
		text.print(console: cons)
		return true
	} else {
		console.print(string: "Could not serialize")
		return false
	}
}
