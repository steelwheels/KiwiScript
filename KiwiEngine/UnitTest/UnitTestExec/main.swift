/**
 * @file		main.swift
 * @brief	Main function for unit test
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

func test(funcname : String, result : Bool)
{
	if(result){
		print("\(funcname) : OK")
	} else {
		print("\(funcname) : NG")
	}
}

test("testStdLib", result: testStdLib())
test("testError", result: testError())



