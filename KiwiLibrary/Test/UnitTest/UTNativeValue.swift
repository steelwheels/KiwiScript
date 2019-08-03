/*
 * @file	UTNativeValue.swift
 * @brief	Test CNNativeValue class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import KiwiLibrary
import KiwiEngine
import CoconutData
import Foundation

public func UTNativeValue(context ctxt: KEContext, console cons: CNConsole) -> Bool
{
	let strct0 = CNNativeStruct(name: "UTStruct")
	let parama = CNNativeValue.numberValue(NSNumber(floatLiteral: 1.2))
	let paramb = CNNativeValue.stringValue("StringParam")
	strct0.setMember(name: "a", value: parama)
	strct0.setMember(name: "b", value: paramb)

	let desc = strct0.JSClassDefinition()
	cons.print(string: "*** Class definition ***\n\(desc)")
	
	return true
}

