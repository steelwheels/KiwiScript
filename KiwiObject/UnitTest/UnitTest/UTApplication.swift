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

public func testApplication(context ctxt: KEContext, config conf: KLConfig, console cons: CNConsole) -> Bool
{
	let application = KMApplication(instanceName: "application", context: ctxt, config: conf)
	cons.print(string: "application is allocated\n")
	if let args = application.arguments {
		cons.print(string: "arguments: count = \(args.count)\n")
	} else {
		cons.print(string: "arguments: count = nil\n")
	}
	return true
}

