/**
 * @file	main.swift
 * @brief	Main function for unit test
 * @par Copyright
 *	Copyright (C) 2017 Steel Wheels Project
 */

import Foundation

var result = true

func test(_ flag : Bool){
	print("RESULT : \(flag)")
	result = result && flag
}

func printTitle(title : String)
{
	
}

print("* KSValue")
test(testKSValue())

print("* KSValueType")
test(testKSValueType())

print("* KSJsonEncoder")
test(testJsonEncoder())

print("* UTConsole")
test(testConsole())

print("* UTMath")
test(testMath())

print("* UTPropertyTable")
test(testPropertyTable())

print("**** SUMMARY\nTOTAL RESULT: ", terminator: "")
if result {
	print("OK")
} else {
	print("NG")
}

