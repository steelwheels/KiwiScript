//
//  UTJsonEncoder.swift
//  KSStdLib
//
//  Created by Tomoo Hamada on 2015/09/01.
//  Copyright (c) 2015年 Steel Wheels Project. All rights reserved.
//

import Foundation
import KSStdLib
import JavaScriptCore

func testJsonEncoder() -> Bool
{
	let context = JSContext()
	
	print("** Bool Object -> ", terminator:"")
	let val0 = JSValue(bool: true, inContext: context)
	decodeValue(val0)
	
	print("** Double Object -> ", terminator:"")
	let val1 = JSValue(double: 1.23, inContext: context)
	decodeValue(val1)
	
	print("** String Object -> ", terminator:"")
	let var2 = JSValue(object: NSString(UTF8String: "Hello, World"), inContext: context)
	decodeValue(var2)
	
	print("** Dictionary Object -> ", terminator:"")
	let dict0 : NSDictionary = ["a":123, "b":234] ;
	let var3 = JSValue(object: dict0, inContext: context)
	decodeValue(var3)
	
	print("** Array object -> ", terminator:"")
	let arr0 : NSArray = [1, 2, 3, 4]
	let var4 = JSValue(object: arr0, inContext: context)
	decodeValue(var4)
	
	return true
}

func decodeValue(value : JSValue)
{
	let encoder = KSJsonEncoder() ;
	let textbuf = encoder.encode(value)
	textbuf.dump()
}
