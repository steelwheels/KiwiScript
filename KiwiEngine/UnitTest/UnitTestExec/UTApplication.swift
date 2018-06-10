/**
 * @file	UTApplication.swift
 * @brief	Unit test for KEApplication class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import Foundation

public func testApplication(console cons: CNConsole) -> Bool
{
	let application = KEApplication(kind: .Terminal)
	application.console.print(string: "application is allocated\n")
	if let args = application.arguments {
		cons.print(string: "arguments: count = \(args.count)\n")
	} else {
		cons.print(string: "arguments: count = nil\n")
	}
	if let config = application.config {
		application.console.print(string: "\(config)\n")
	} else {
		cons.error(string: "No config object")
	}
	return true
}

