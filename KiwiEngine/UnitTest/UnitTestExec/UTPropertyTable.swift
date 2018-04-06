/**
 * @file	UTPropertyTable.swift
 * @brief	Unit test for KEPropertyTable class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import KiwiEngine
import Canary
import JavaScriptCore
import Foundation

public func testPropertyTable(console cons: CNConsole) -> Bool
{
	let vm = JSVirtualMachine()
	let context = KEContext(virtualMachine: vm!)

	let table0  = KEPropertyTable(context: context)
	let point0  = CGPoint(x: 10.0, y: 11.1)

	addProperty(propertyTable: table0, propertyName: "undefined", propertyValue: JSValue(undefinedIn: context), console: cons)
	addProperty(propertyTable: table0, propertyName: "null", propertyValue: JSValue(nullIn: context), console: cons)
	addProperty(propertyTable: table0, propertyName: "bool", propertyValue: JSValue(bool: true, in: context), console: cons)
	addProperty(propertyTable: table0, propertyName: "int32", propertyValue: JSValue(int32: -1234, in: context), console: cons)
	addProperty(propertyTable: table0, propertyName: "uInt32", propertyValue: JSValue(uInt32: 2345, in: context), console: cons)
	addProperty(propertyTable: table0, propertyName: "double", propertyValue: JSValue(double: 1.234, in: context), console: cons)
	addProperty(propertyTable: table0, propertyName: "point", propertyValue: JSValue(point: point0, in: context), console: cons)

	return true
}

private func addProperty(propertyTable table: KEPropertyTable, propertyName name: String, propertyValue value: JSValue, console cons: CNConsole)
{
	table.addListener(property: name, listener: {
		(_ value: JSValue) -> Void in
		let valstr: String
		if let str = value.toString() {
			valstr = str
		} else {
			valstr = "<Can not convert>"
		}
		cons.print(string: "Listener: \(name) = \(valstr)\n")
	})
	table.set(name, value)
}
