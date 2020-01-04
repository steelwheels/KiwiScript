/**
 * @file	UTShellComnand.swift
 * @brief	Test function for shell thread
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import KiwiShell
import CoconutShell
import CoconutData
import Foundation

public func UTShellCommand(console cons: CNConsole) -> Bool
{
	cons.print(string: "// shell command: 0\n")
	let cmd0 = CNSystemShellCommandStatement(shellCommand: "command-0")
	//cons.print(string: cmd0.toScript().joined(separator: "\n") + "\n")

	cons.print(string: "// script command: 1\n")
	let cmd1 = CNSystemShellCommandStatement(shellCommand: "command-1")
	//cons.print(string: cmd1.toScript().joined(separator: "\n") + "\n")

	cons.print(string: "// command process: 2\n")
	let cmd2 = CNProcessShellStatement()
	cmd2.add(command: cmd0)
	cmd2.add(command: cmd1)
	//cons.print(string: cmd2.toScript().joined(separator: "\n") + "\n")

	cons.print(string: "// shell command: 3\n")
	let cmd3 = CNSystemShellCommandStatement(shellCommand: "command-3")
	//cons.print(string: cmd3.toScript().joined(separator: "\n") + "\n")

	cons.print(string: "// script command: 4\n")
	let cmd4 = CNSystemShellCommandStatement(shellCommand: "command-4")
	//cons.print(string: cmd4.toScript().joined(separator: "\n") + "\n")

	cons.print(string: "// command process: 5\n")
	let cmd5 = CNProcessShellStatement()
	cmd5.add(command: cmd3)
	cmd5.add(command: cmd4)
	//cons.print(string: cmd5.toScript().joined(separator: "\n") + "\n")

	cons.print(string: "// command pipeline: 6\n")
	let cmd6 = CNPipelineShellStatement()
	cmd6.add(process: cmd2)
	cmd6.add(process: cmd5)
	cmd6.exitName = "extval6"
	cons.print(string: cmd6.toScript().joined(separator: "\n") + "\n")

	return true
}


