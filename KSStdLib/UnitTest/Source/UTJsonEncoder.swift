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

public func testJsonEncoder() -> Bool
{
	let console = CNTextConsole()
	if let context = JSContext() {
		print("** Bool Object -> ", terminator:"")
		let val0 = JSValue(bool: true, in: context)
		decodeValue(console: console, value: val0)
	
		print("** Double Object -> ", terminator:"")
		let val1 = JSValue(double: 1.23, in: context)
		decodeValue(console: console, value: val1)
	
		print("** String Object -> ", terminator:"")
		let var2 = JSValue(object: NSString(utf8String: "Hello, World"), in: context)
		decodeValue(console: console, value: var2)
	
		print("** Dictionary Object -> ", terminator:"")
		let dict0 : NSDictionary = ["a":123, "b":234] ;
		let var3 = JSValue(object: dict0, in: context)
		decodeValue(console: console, value: var3)
	
		print("** Array object -> ", terminator:"")
		let arr0 : NSArray = [1, 2, 3, 4]
		let var4 = JSValue(object: arr0, in: context)
		decodeValue(console: console, value: var4)
	
		print("** Combination object -> ", terminator:"")
		let dict1 : NSDictionary = ["i0":dict0, "i1":arr0]
		let var5 = JSValue(object: dict1, in: context)
		decodeValue(console: console, value: var5)
	
		return true
	} else {
		print("[Error] Can not allocate JSContext")
		return false
	}
}

public func decodeValue(console cons: CNConsole, value val: JSValue?)
{
	if let v = val {
		let encdict = KSValueCoder.encode(value: v)
		let (encstr, encerr)  = CNJSONFile.serialize(dictionary: encdict)
		if let error = encerr {
			let errmsg = "[Error] " + error.toString()
			cons.print(text: CNConsoleText(string: errmsg))
		} else if let str = encstr {
			let lines = str.components(separatedBy: "\n")
			cons.print(text: CNConsoleText(strings: lines))
		} else {
			fatalError("Can not happen (1)")
		}
	} else {
		fatalError("Can not happen (2)")
	}
}
