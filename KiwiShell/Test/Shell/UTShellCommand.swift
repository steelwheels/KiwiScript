/**
 * @file	UTShellComnand.swift
 * @brief	Test function for shell thread
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import KiwiShell
import CoconutData
import Foundation

public func UTShellCommand(console cons: CNConsole) -> Bool
{
	cons.print(string: "// shell command: 0\n")
	let stmt0 = KHShellCommandStatement(shellCommand: "command-0")
	//cons.print(string: stmt0.toScript().joined(separator: "\n") + "\n")

	cons.print(string: "// script command: 1\n")
	let stmt1 = KHShellCommandStatement(shellCommand: "command-1")
	//cons.print(string: stmt1.toScript().joined(separator: "\n") + "\n")

	cons.print(string: "// command process: 2\n")
	let stmt2 = KHPipelineStatement()
	stmt2.add(statement: stmt0)
	stmt2.add(statement: stmt1)
	//cons.print(string: stmt2.toScript().joined(separator: "\n") + "\n")

	cons.print(string: "// shell command: 3\n")
	let stmt3 = KHShellCommandStatement(shellCommand: "command-3")
	//cons.print(string: stmt3.toScript().joined(separator: "\n") + "\n")

	cons.print(string: "// script command: 4\n")
	let stmt4 = KHShellCommandStatement(shellCommand: "command-4")
	//cons.print(string: stmt4.toScript().joined(separator: "\n") + "\n")

	cons.print(string: "// command process: 5\n")
	let stmt5 = KHPipelineStatement()
	stmt5.add(statement: stmt3)
	stmt5.add(statement: stmt4)
	//cons.print(string: stmt5.toScript().joined(separator: "\n") + "\n")

	cons.print(string: "// command pipeline: 6\n")
	let stmt6 = KHMultiStatements()
	stmt6.add(statement: stmt2)
	stmt6.add(statement: stmt5)
	stmt6.dump(indent: 0, to: cons)

	return true
}


