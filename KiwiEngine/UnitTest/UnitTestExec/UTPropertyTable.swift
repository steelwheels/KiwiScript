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
	var result  = true

	let vm      = JSVirtualMachine()
	let context = KEContext(virtualMachine: vm)
	let table0  = KEPropertyTable(context: context)

	/* Add boolean property */
	let prop0 = "visible"
	table0.set(prop0, JSValue(bool: true, in: context))
	let ret0 = table0.get(prop0)
	cons.print(string: "proprty : true -> \(ret0)\n")

	/* Add listner function */
	cons.print(string: "*** Add listner function\n")
	table0.addListener(property: prop0, listener: {
		(value: Any) -> Void in
		if let v = value as? JSValue {
			let iv = v.toBool()
			cons.print(string: "* Listener: value \(iv)\n")
		} else {
			cons.print(string: "* Listener: Unknown object: \(value)\n")
		}
	})
	table0.set(prop0, JSValue(bool: false, in: context))

	cons.print(string: "*** Call set() function\n")
	let tableprop = NSString(string: "table")
	context.setObject(table0, forKeyedSubscript: tableprop)
	let script0 = "table.set(\"visible\", true) ;"
	if !UTExecute(context: context, console: cons, script: script0) {
		result = false
	}

	return result
}

