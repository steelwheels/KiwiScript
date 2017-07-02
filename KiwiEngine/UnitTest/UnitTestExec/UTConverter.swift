/**
 * @file	UTConverter.swift
 * @brief	Unit test for KiwiEngine framework
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import KiwiEngine
import Canary
import JavaScriptCore
import Foundation

public func testConverter(console cons: CNConsole) -> Bool
{
	let vm      = JSVirtualMachine()
	let context = KEContext(virtualMachine: vm)

	let val0 = CNValue(booleanValue: true)
	convert(message: "type:bool, value:true", value: val0, context: context, console: cons)

	let val1 = CNValue(characterValue: "c")
	convert(message: "type:char, value:\"c\"", value: val1, context: context, console: cons)

	let val2 = CNValue(intValue: -1234)
	convert(message: "type:int, value:-1234", value: val2, context: context, console: cons)

	let val3 = CNValue(uIntValue: 1234)
	convert(message: "type:uint, value:1234", value: val3, context: context, console: cons)

	let val4 = CNValue(floatValue: 12.34)
	convert(message: "type:float, value:12.34", value: val4, context: context, console: cons)

	let val5 = CNValue(doubleValue: -12.34)
	convert(message: "type:double, value:-12.34", value: val5, context: context, console: cons)

	let val6 = CNValue(stringValue: "Hello,World")
	convert(message: "type:string, value:\"Hello, world\"", value: val6, context: context, console: cons)

	let val7 = CNValue(dateValue: Date(timeIntervalSince1970: 10000))
	convert(message: "type:date, value:Now", value: val7, context: context, console: cons)

	let val8 = CNValue(arrayValue: [val0])
	convert(message: "type:array, value:[true]", value: val8, context: context, console: cons)

	let val9 = CNValue(setValue: [val1])
	convert(message: "type:array, value:[\"c\"]", value: val9, context: context, console: cons)

	let val10 = CNValue(dictionaryValue: ["a":val8])
	convert(message: "type:dict, value:[dict]", value: val10, context: context, console: cons)

	return true
}

private func convert(message msg: String, value src: CNValue, context ctxt: KEContext, console cons: CNConsole)
{
	let dst = KEValueConverter.convert(source: src, context: ctxt)

	cons.print(string: "* [\(msg)] ")

	let srcstr = src.description
	cons.print(string: srcstr + " -> ")

	let dsttext = KESerializeValue(value: dst)
	dsttext?.print(console: cons)

}

