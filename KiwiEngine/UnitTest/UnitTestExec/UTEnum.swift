/**
 * @file	UTEnum.swift
 * @brief	Serialize/Deserialize JSValue
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import Foundation

public func testEnum(console cons: CNConsole) -> Bool
{
	var result = true
	
	let enumdef1 = KEEnum(typeName: "Week")
	enumdef1.setValue(value: 0, forKey: "Sun")
	enumdef1.setValue(value: 1, forKey: "Mon")
	enumdef1.setValue(value: 2, forKey: "Tue")

	if let script = enumdef1.makeScript() {
		console.print(string: script)
	} else {
		console.print(string: "[Error] Can not make script from enum")
		result = false
	}

	let enumdef2 = KEEnum(typeName: "Month")
	enumdef2.setValue(value: 0, forKey: "Jan")
	enumdef2.setValue(value: 1, forKey: "Feb")
	enumdef2.setValue(value: 2, forKey: "Mar")

	let table = KEEnumTable()
	table.addEnum(enumType: enumdef1)
	table.addEnum(enumType: enumdef2)

	search(table: table, byTypeName: "Week", console: cons)
	search(table: table, byTypeName: "Year", console: cons)
	search(table: table, byMemberName: "Feb", console: cons)
	
	return result
}

private func search(table tab: KEEnumTable, byTypeName name: String, console cons: CNConsole)
{
	console.print(string: "search by \(name) -> ")
	if let etype = tab.search(byTypeName: name) {
		if let script = etype.makeScript() {
			console.print(string: script)
		} else {
			console.print(string: "[Error] Can not make script from enum")
		}
	} else {
		console.print(string: "No found\n")
	}
}

private func search(table tab: KEEnumTable, byMemberName name: String, console cons: CNConsole)
{
	console.print(string: "search by \(name) -> ")
	let etypes = tab.search(byMemberName: name)
	if etypes.count > 0 {
		console.print(string: "Found -> ")
		for etype in etypes {
			console.print(string: etype.typeName + ", ")
		}
		console.print(string: "\n")
	} else {
		console.print(string: "Not found\n")
	}
}


