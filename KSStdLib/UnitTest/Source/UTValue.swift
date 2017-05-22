/**
 * @file	UTValue.swift
 * @brief	Unit test for KSValue
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import KSStdLib
import Canary
import Foundation
import JavaScriptCore

func testKSValue(console cons: CNConsole) -> Bool {
	testKinds(console: cons)
	
	let context = JSContext()
	parseNumber(console: cons, title: "int32 ",  value: JSValue(int32: 123, in: context))
	parseNumber(console: cons, title: "UInt32", value: JSValue(uInt32: 123, in: context))
	parseNumber(console: cons, title: "double", value: JSValue(double: 123.4, in: context))
	
	return true ;
}

func testKinds(console cons: CNConsole){
	cons.print(string: "** Print kind strings\n")
	testKind(console: cons, title: "char  ", kind: KSValueKind.BooleanValue)
	testKind(console: cons, title: "number", kind: KSValueKind.NumberValue)
}

func testKind(console cons: CNConsole, title: String, kind : KSValueKind){
	let kindstr = kind.toString()
	cons.print(string: "\(title) -> \(kindstr)\n")
}

func parseNumber(console cons: CNConsole, title tl: String, value val: JSValue){
	let kind = val.kind
	let kindstr = kind.toString()
	cons.print(string: "\(tl): \(val.description) : \(kindstr)\n")
}
