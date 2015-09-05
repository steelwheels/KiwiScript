//
//  main.swift
//  UnitTest
//
//  Created by Tomoo Hamada on 2015/08/28.
//  Copyright (c) 2015年 Steel Wheels Project. All rights reserved.
//

import Foundation

var result = true

func test(title : String, flag : Bool){
	print("**** \(title) : \(flag)") ;
	result = result && flag
}

test("KSValue", flag: testKSValue())
test("KSJsonEncoder", flag: testJsonEncoder())

print("**** SUMMARY\nTOTAL RESULT: ", terminator: "")
if result {
	print("OK")
} else {
	print("NG")
}

