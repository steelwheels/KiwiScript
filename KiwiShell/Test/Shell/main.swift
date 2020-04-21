/**
 * @file	main.swift
 * @brief	Main function of shell test
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiShell
import KiwiEngine
import KiwiLibrary
import CoconutData
import CoconutShell
import JavaScriptCore
import Foundation

public func main()
{
	let inhdl   = FileHandle.standardInput
	let outhdl  = FileHandle.standardOutput
	let errhdl  = FileHandle.standardError
	let console = CNFileConsole(input: inhdl, output: outhdl, error: errhdl)

	let manager = KLBuiltinScripts.shared
	manager.setup(subdirectory: "Binary", forClass: KHShellThread.self)

	console.print(string: "***** UTShellCommand\n")
	let res0 = UTShellCommand(console: console)

	console.print(string: "***** UTParser\n")
	let res3 = UTParser(console: console)

	console.print(string: "***** UTScriptManager\n")
	let res2 = UTScriptManager(console: console)

	console.print(string: "***** UTScript\n")
	let res4 = UTScript(input: inhdl, output: outhdl, error: errhdl, console: console)

	if res0 && res2 && res3 {
		console.print(string: "Summary: OK\n")
	} else {
		console.print(string: "Summary: NG\n")
	}
}

main()

