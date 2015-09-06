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
	
	return true
}

func decodeValue(value : JSValue)
{
	let encoder = KSJsonEncoder() ;
	let textbuf = encoder.encode(value)
	textbuf.dump()
}
