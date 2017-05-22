/**
 * @file	UTJsonCoder.swift
 * @brief	Unit test for coder
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation
import JavaScriptCore
import Canary
import KSStdLib

public func testJsonEncoder(console cons: CNConsole) -> Bool
{
	if let context = JSContext() {
		console.print(string: "** Bool Object -> ")
		let val0 = JSValue(bool: true, in: context)
		decodeValue(console: console, value: val0)
	
		console.print(string: "** Double Object -> ")
		let val1 = JSValue(double: 1.23, in: context)
		decodeValue(console: console, value: val1)
	
		console.print(string: "** String Object -> ")
		let var2 = JSValue(object: NSString(utf8String: "Hello, World"), in: context)
		decodeValue(console: console, value: var2)
	
		console.print(string: "** Dictionary Object -> ")
		let dict0 : NSDictionary = ["a":123, "b":234] ;
		let var3 = JSValue(object: dict0, in: context)
		decodeValue(console: console, value: var3)
	
		console.print(string: "** Array object -> ")
		let arr0 : NSArray = [1, 2, 3, 4]
		let var4 = JSValue(object: arr0, in: context)
		decodeValue(console: console, value: var4)
	
		console.print(string: "** Combination object -> ")
		let dict1 : NSDictionary = ["i0":dict0, "i1":arr0]
		let var5 = JSValue(object: dict1, in: context)
		decodeValue(console: console, value: var5)
	
		return true
	} else {
		console.print(string: "[Error] Can not allocate JSContext\n")
		return false
	}
}

public func decodeValue(console cons: CNConsole, value val: JSValue?)
{
	if let v = val {
		let encdict = KSValueCoder.encode(value: v)
		let (encstr, encerr)  = CNJSONFile.serialize(dictionary: encdict)
		if let error = encerr {
			let errmsg = "[Error] " + error.toString() + "\n"
			cons.print(string: errmsg)
		} else if let str = encstr {
			cons.print(string: str+"\n")
		} else {
			fatalError("Can not happen (1)")
		}
	} else {
		fatalError("Can not happen (2)")
	}
}
