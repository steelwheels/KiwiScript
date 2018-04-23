/**
 * @file		main.swift
 * @brief	Main function for unit test
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import CoconutData
import Foundation

let console = CNFileConsole()
var summary = true

func test(funcName fn:String, result res:Bool) -> Bool
{
	if(res){
		console.print(string: "\(fn) : OK\n")
	} else {
		console.print(string: "\(fn) : NG\n")
	}
	return res
}

summary = test(funcName: "testError", result: testError(console: console)) && summary
summary = test(funcName: "testObject", result: testObject(console: console)) && summary
summary = test(funcName: "testPropertyTable", result: testPropertyTable(console: console)) && summary
summary = test(funcName: "testPropertyTable2", result: testPropertyTable2(console: console)) && summary
summary = test(funcName: "testValue", result: testValue(console: console)) && summary
summary = test(funcName: "testEnum", result: testEnum(console: console)) && summary


if summary {
	console.print(string: "SUMMARY: OK")
} else {
	console.print(string: "SUMMARY: NG")
}



