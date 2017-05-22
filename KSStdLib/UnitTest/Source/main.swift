/**
 * @file	main.swift
 * @brief	Main function for unit test
 * @par Copyright
 *	Copyright (C) 2017 Steel Wheels Project
 */

import Canary
import Foundation

var result = true
let console = CNFileConsole(file: CNTextFile.stdout)

func test(_ flag : Bool){
	console.print(string: "RESULT : \(flag)\n")
	result = result && flag
}

func printTitle(title : String)
{
	
}

console.print(string: "* KSValue\n")
test(testKSValue(console: console))

console.print(string: "* KSValueType\n")
test(testKSValueType(console: console))

console.print(string: "* KSJsonEncoder\n")
test(testJsonEncoder(console: console))

console.print(string: "* UTConsole\n")
test(testConsole())

console.print(string: "* UTDebug\n")
test(testDebug())

console.print(string: "* UTMath\n")
test(testMath())

console.print(string: "* UTPropertyTable\n")
test(testPropertyTable(console: console))

console.print(string: "**** SUMMARY\nTOTAL RESULT: ")
if result {
	console.print(string: "OK")
} else {
	console.print(string: "NG")
}

