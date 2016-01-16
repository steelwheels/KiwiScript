//
//  UTJsonEncoder.swift
//  KSStdLib
//
//  Created by Tomoo Hamada on 2015/09/01.
//  Copyright (c) 2015年 Steel Wheels Project. All rights reserved.
//

import Foundation
import JavaScriptCore
import Canary
import KSStdLib

public func testJsonEncoder() -> Bool
{
	let console = CNTextConsole()
	let context = JSContext()
	
	print("** Bool Object -> ", terminator:"")
	let val0 = JSValue(bool: true, inContext: context)
	decodeValue(console, value: val0)
	
	print("** Double Object -> ", terminator:"")
	let val1 = JSValue(double: 1.23, inContext: context)
	decodeValue(console, value: val1)
	
	print("** String Object -> ", terminator:"")
	let var2 = JSValue(object: NSString(UTF8String: "Hello, World"), inContext: context)
	decodeValue(console, value: var2)
	
	print("** Dictionary Object -> ", terminator:"")
	let dict0 : NSDictionary = ["a":123, "b":234] ;
	let var3 = JSValue(object: dict0, inContext: context)
	decodeValue(console, value: var3)
	
	print("** Array object -> ", terminator:"")
	let arr0 : NSArray = [1, 2, 3, 4]
	let var4 = JSValue(object: arr0, inContext: context)
	decodeValue(console, value: var4)
	
	print("** Combination object -> ", terminator:"")
	let dict1 : NSDictionary = ["i0":dict0, "i1":arr0]
	let var5 = JSValue(object: dict1, inContext: context)
	decodeValue(console, value: var5)
	
	return true
}

public func decodeValue(console : CNConsole, value : JSValue)
{
	let encdict = KSValueCoder.encode(value)
	let (encstr, encerr)  = CNJSONFile.serializeToString(encdict)
	if let error = encerr {
		let errmsg = "[Error] " + error.toString()
		console.printLine(errmsg)
	} else if let str = encstr {
		let lines = str.componentsSeparatedByString("\n")
		console.printLines(lines)
	} else {
		fatalError("Can not happen")
	}
}
