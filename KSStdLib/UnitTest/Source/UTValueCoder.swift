//
//  UTValueCoder.swift
//  KSStdLib
//
//  Created by Tomoo Hamada on 2015/09/08.
//  Copyright © 2015年 Steel Wheels Project. All rights reserved.
//

import Foundation
import JavaScriptCore
import Canary
import KSStdLib


func testValueCoder() -> Bool
{
	let result = testDirectCoding()
	return result
}

private func testDirectCoding() -> Bool
{
	var result = true
	let context = JSContext()
	
	let point = CGPointMake(1.2, 3.4)
	let ptval = KSEncodePoint(point)
	let ptjsv = JSValue(object: ptval, inContext: context)
	dumpValue(ptjsv)
	if let revpt = KSDecodePoint(ptval) {
		if revpt.x == point.x && revpt.y == point.y {
			print("OK ... Encode/Decode CGPoint are succeeded")
		} else {
			print("Error: invalid value \(ptval)")
			result = false
		}
	} else {
		print("Error: can not decode \(ptval)")
		result = false
	}
	
	let size = CGSizeMake(4.5, 5.6)
	let szval = KSEncodeSize(size)
	let szjsv = JSValue(object: szval, inContext: context)
	dumpValue(szjsv)
	if let revsz = KSDecodeSize(szval) {
		if revsz.width == size.width && revsz.height == size.height {
			print("OK ... Encode/Decode CGSize are succeeded")
		} else {
			print("Error: invalid value \(szval)")
			result = false
		}
	} else {
		print("Error: can not decode \(szval)")
		result = false
	}
	
	var dict : [String:AnyObject] = ["key":"value"]
	let dictelm : [Int] = [1,2,3,4]
	KSAddMember(&dict, key: "a", value: Double(10.0))
	KSAddMember(&dict, key: "b", value: dictelm)
	let dictsv = JSValue(object: dict, inContext: context)
	dumpValue(dictsv)
	if let elmval : NSNumber = KSGetMember(dict, key: "a") {
		if elmval.doubleValue == 10.0 {
			print("OK ... Get/set member are succeeded")
		} else {
			print("Error: invalid value \(elmval)")
			result = false
		}
	} else {
		print("Error: can not decode \(dict)")
		result = false
	}
	
	return result
}

private func dumpValue(value : JSValue)
{
	let encoder = KSJsonEncoder()
	let buf = encoder.encode(value)
	buf.dump()
}
