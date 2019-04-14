/**
 * @file	UTApplication.swift
 * @brief	Unit test for KEApplication class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiObject
import KiwiLibrary
import KiwiEngine
import CoconutData
import Foundation

public func testProgram(context ctxt: KEContext, console cons: CNConsole) -> Bool
{
	let _ = KMProgram(instanceName: "program", context: ctxt, console: cons)
	cons.print(string: "program is allocated\n")
	return true
}

