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

print("* KSValue")
test(testKSValue())

print("* KSJsonEncoder")
test(testJsonEncoder())

print("* KSValueCoder")
test(testValueCoder())

print("**** SUMMARY\nTOTAL RESULT: ", terminator: "")
if result {
	print("OK")
} else {
	print("NG")
}

