//
//  main.swift
//  UnitTest
//
//  Created by Tomoo Hamada on 2018/10/23.
//  Copyright © 2018 Steel Wheels Project. All rights reserved.
//

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

//summary = test(funcName: "testError", result: testError(console: console)) && summary
//summary = test(funcName: "testObject", result: testObject(console: console)) && summary
summary = test(funcName: "testPropertyTable", result: testPropertyTable(console: console)) && summary
summary = test(funcName: "testPropertyTable2", result: testPropertyTable2(console: console)) && summary
summary = test(funcName: "testApplication", result: testApplication(console: console)) && summary
//summary = test(funcName: "testCompiler", result: testCompiler(console: console)) && summary

if summary {
	console.print(string: "SUMMARY: OK")
} else {
	console.print(string: "SUMMARY: NG")
}

