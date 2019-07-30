/**
 * @file	UTStruct.swift
 * @brief	Unit test for KiwiEngine framework
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
import JavaScriptCore
import KiwiEngine
import Foundation

public func testStruct(console cons: CNConsole, config conf: KEConfig) -> Bool
{
	let model = KEStruct(name: "UTStruct")
	model.setMember(name: "a", value: CNNativeValue.numberValue(NSNumber(booleanLiteral: true)))
	model.setMember(name: "b", value: CNNativeValue.stringValue("Hello, world!!"))

	let desc = model.JSClassDefinition()
	cons.print(string: desc)

	return true
}

