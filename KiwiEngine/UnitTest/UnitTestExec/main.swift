/**
 * @file		main.swift
 * @brief	Main function for unit test
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import Foundation

let console = CNFileConsole()
let config  = KEConfig(kind: .Terminal, doStrict: true, doVerbose: true)

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
summary = test(funcName: "testCompiler", result: testCompiler(console: console)) && summary
summary = test(funcName: "testExec", result: testExec(console: console)) && summary
summary = test(funcName: "testOperation", result: testOperation(console: console, config: config)) && summary
summary = test(funcName: "testOperationQueues", result: testOperationQueues(console: console)) && summary

if summary {
	console.print(string: "SUMMARY: OK\n")
} else {
	console.print(string: "SUMMARY: NG\n")
}



