/*
 * @file	UTColor.swift
 * @brief	Unit test for KLColor, KLColorManager class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import KiwiLibrary
import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

public func UTColor(context ctxt: KEContext, console cons: CNFileConsole) -> Bool
{
	let stmt = "console.log(\"black = \" + Color.black) ;"
	ctxt.evaluateScript(stmt)
	return true
}

