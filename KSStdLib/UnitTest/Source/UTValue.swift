/**
 * @file	UTValue.swift
 * @brief	Unit test for KSValue
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation
import JavaScriptCore
import KSStdLib

func testKSValue() -> Bool {
	testKinds()
	
	let context = JSContext()
	parseNumber(title: "int32 ",  value: JSValue(int32: 123, in: context))
	parseNumber(title: "UInt32", value: JSValue(uInt32: 123, in: context))
	parseNumber(title: "double", value: JSValue(double: 123.4, in: context))
	
	return true ;
}

func testKinds(){
	print("** Print kind strings")
	testKind(title: "char  ", kind: KSValueKind.BooleanValue)
	testKind(title: "number", kind: KSValueKind.NumberValue)
}

func testKind(title: String, kind : KSValueKind){
	let kindstr = kind.toString()
	print("\(title) -> \(kindstr)")
}

func parseNumber(title tl: String, value val: JSValue){
	let kind = val.kind
	let kindstr = kind.toString()
	print("\(tl): \(val.description) : \(kindstr)")
}
