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
	let res0 = testShellCommand(command: "cat", console: cons)
	let res1 = testShellCommand(command: "cat < @inpipe", console: cons)
	let res2 = testShellCommand(command: "cat < inpipe >  @outpipe 2>@errpipe", console: cons)
	return res0 && res1 && res2
}

private func testShellCommand(command cmd: String, console cons: CNConsole) -> Bool {
	cons.print(string: "// command for \(cmd)\n")
	let cmd0 = KHShellCommand(command: cmd)
	if let err = cmd0.compile() {
		cons.print(string: "[Error] 1 " + err.toString() + "\n")
		return false
	}
	dumpShellCommand(command: cmd0, console: cons)

	cons.print(string: "// process for \(cmd)\n")
	let cmd1  = KHShellCommand(command: cmd)
	let proc1 = KHShellProcess()
	proc1.add(command: cmd1)
	if let err = proc1.compile() {
		cons.print(string: "[Error] 2 " + err.toString() + "\n")
		return false
	}
	let script1 = proc1.toScript()
	cons.print(string: "Script1: " + script1 + "\n")

	return true
}

private func dumpShellCommand(command cmd: KHShellCommand, console cons: CNConsole) {
	let command = cmd.command
	let inpipe: String
	if let pipe = cmd.inputName {
		inpipe = pipe
	} else {
		inpipe = "<no inpipe>"
	}
	let outpipe: String
	if let pipe = cmd.outputName {
		outpipe = pipe
	} else {
		outpipe = "<no outpipe>"
	}
	let errpipe: String
	if let pipe = cmd.errorName {
		errpipe = pipe
	} else {
		errpipe = "<no errpipe>"
	}
	cons.print(string: "{ \"\(command)\"/\(inpipe)/\(outpipe)/\(errpipe) }\n")
}


