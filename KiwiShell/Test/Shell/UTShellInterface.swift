/**
* @file	UTShell.swift
* @brief	Test function for shell thread
* @par Copyright
*   Copyright (C) 2019 Steel Wheels Project
*/

import KiwiShell
import CoconutData
import Foundation

public func UTShellInterface(console cons: CNConsole) -> Bool
{
	testInterface(string: "Hello, world", console: cons)
	testInterface(string: "> echo \"Hello\"", console: cons)
	testInterface(string: "()> echo \"Hello\"", console: cons)
	testInterface(string: "(a)> echo \"Hello\"", console: cons)
	testInterface(string: "(a b)> echo \"Hello\"", console: cons)
	testInterface(string: "(a, b)> echo \"Hello\"", console: cons)
	testInterface(string: "(a, b, c)> echo \"Hello\"", console: cons)
	testInterface(string: "(a, b, c, d)> echo \"Hello\"", console: cons)
	testInterface(string: "(a, b, c, d, e)> echo \"Hello\"", console: cons)
	testInterface(string: "(a, b, c, d): > echo \"Hello\"", console: cons)
	testInterface(string: "(a, b, c, d): e > echo \"Hello\"", console: cons)
	return true
}

private func testInterface(string str: String, console cons: CNConsole) {
	cons.print(string: str + " ===> ")
	if let intf = KHShellInterface.parse(string: str) {
		intf.dump(to: cons)
	} else {
		cons.print(string: "Not interface\n")
	}
}
