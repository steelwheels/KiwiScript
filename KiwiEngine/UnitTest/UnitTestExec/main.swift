/**
 * @file		main.swift
 * @brief	Main function for unit test
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Canary
import Foundation

let console = CNFileConsole(file: CNTextFile.stdout)
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
summary = test(funcName: "testConverter", result: testConverter(console: console)) && summary
summary = test(funcName: "testPropertyTable", result: testPropertyTable(console: console)) && summary
summary = test(funcName: "testSerialize", result: testSerialize(console: console)) && summary
summary = test(funcName: "testEnum", result: testEnum(console: console)) && summary


if summary {
	console.print(string: "SUMMARY: OK")
} else {
	console.print(string: "SUMMARY: NG")
}



