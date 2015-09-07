//
//  UTValue.swift
//  KSStdLib
//
//  Created by Tomoo Hamada on 2015/08/28.
//  Copyright (c) 2015年 Steel Wheels Project. All rights reserved.
//

import Foundation
import JavaScriptCore

func testKSValue() -> Bool {
	testKinds()
	
	let context = JSContext()
	parseNumber("int32", val: JSValue(int32: 123, inContext: context))
	parseNumber("UInt32", val: JSValue(UInt32: 123, inContext: context))
	parseNumber("double", val: JSValue(double: 123.4, inContext: context))
	
	return true ;
}

func testKinds(){
	print("** Print kind strings")
	testKind("char  ", kind: KSValueKind.BooleanValue)
	testKind("number", kind: KSValueKind.NumberValue)
}

func testKind(title: String, kind : KSValueKind){
	let kindstr = kind.toString()
	print("\(title) -> \(kindstr)")
}

func parseNumber(title: String, val : JSValue){
	let kind = KSValue.kindOfValue(val)
	let kindstr = kind.toString()
	print("\(title): \(val.description) : \(kindstr)")
}