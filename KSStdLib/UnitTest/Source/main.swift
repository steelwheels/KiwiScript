//
//  main.swift
//  UnitTest
//
//  Created by Tomoo Hamada on 2015/08/28.
//  Copyright (c) 2015年 Steel Wheels Project. All rights reserved.
//

import Foundation

var result = true

func test(flag : Bool){
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

print("* KSValueCoder")
test(testValueCoder())

print("* UTConsole")
test(testConsole())

print("**** SUMMARY\nTOTAL RESULT: ", terminator: "")
if result {
	print("OK")
} else {
	print("NG")
}

