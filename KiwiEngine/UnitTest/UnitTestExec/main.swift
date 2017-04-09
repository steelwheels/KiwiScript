/**
 * @file		main.swift
 * @brief	Main function for unit test
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

var summary = true

func test(funcName fn:String, result res:Bool) -> Bool
{
	if(res){
		print("\(fn) : OK")
	} else {
		print("\(fn) : NG")
	}
	return res
}

summary = test(funcName: "testStdLib", result: testStdLib()) && summary
summary = test(funcName: "testError", result: testError()) && summary
summary = test(funcName: "testObject", result: testObject()) && summary

if summary {
	print("SUMMARY: OK")
} else {
	print("SUMMARY: NG")
}



