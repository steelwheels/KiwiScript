/**
 * @file		main.swift
 * @brief	Main function for unit test
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

var summary = true

func test(funcname:String, result:Bool) -> Bool
{
	if(result){
		print("\(funcname) : OK")
	} else {
		print("\(funcname) : NG")
	}
	return result
}

summary = test("testStdLib", result: testStdLib()) && summary
summary = test("testError", result: testError()) && summary
summary = test("testObject", result: testObject()) && summary

if summary {
	print("SUMMARY: OK")
} else {
	print("SUMMARY: NG")
}



