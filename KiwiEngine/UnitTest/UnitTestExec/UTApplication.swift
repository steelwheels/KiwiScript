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
	let application = KEApplication()
	application.console.print(string: "application is allocated\n")
	if let name = application.name {
		cons.print(string: "app-name: \(name)\n")
	} else {
		cons.print(string: "app-name: <none>\n")
	}
	if let config = application.config {
		application.console.print(string: "\(config)\n")
	} else {
		cons.error(string: "No config object")
	}
	return true
}

