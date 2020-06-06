/**
 * @file	UTParser.swift
 * @brief	Unit test for KMObjectParser class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

import KiwiObject
import CoconutData
import Foundation

public func parserTest(console cons: CNConsole) -> Bool {
	var result = true
	let stmt0  = "{ a: int 10 }"
	let stmt1  = "{ a: int 10 } // comment"
	let stmt2  =   "{\n"
		     + "  a: int 10 \n"
		     + "  b: Object {\n"
		     + "    c: float 12.3\n"
		     + "  }\n"
		     + "}"
	for stmt in [stmt0, stmt1, stmt2] {
		let res0 = parse(string: stmt, console: cons)
		result = result && res0
	}
	return result
}

private func parse(string str: String, console cons: CNConsole) -> Bool
{
	let result: Bool
	let parser = KMObjectParser()
	switch parser.parse(source: str) {
	case .ok(let obj):
		let dumper = KMObjectDumper()
		let text   = dumper.dump(object: obj)
		text.print(console: cons)
		result = true
	case .error(let err):
		cons.print(string: "[Error] \(err.description)\n")
		result = false
	}
	return result
}
