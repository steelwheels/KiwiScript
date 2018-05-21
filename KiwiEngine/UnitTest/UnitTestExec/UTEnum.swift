/**
 * @file	UTEnum.swift
 * @brief	Serialize/Deserialize JSValue
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

public func testEnum(console cons: CNConsole) -> Bool
{
	let vm      = JSVirtualMachine()
	let context = KEContext(virtualMachine: vm!)

	let colorobj = KEEnumObject(context: context)
	colorobj.set(name: "black", value: 0)
	colorobj.set(name: "red", value: 1)

	let dirobj = KEEnumObject(context: context)
	dirobj.set(name: "up", value: 0)
	dirobj.set(name: "down", value: 2)

	let table = KEEnumTable()
	table.set(name: "Color", object: colorobj)
	table.set(name: "Direction", object: dirobj)

	var result = true
	if let val = table.value(forClass: "Color", forMember: "black") {
		if val != 0 {
			result = false
		}
	} else {
		result = false
	}
	return result
}


