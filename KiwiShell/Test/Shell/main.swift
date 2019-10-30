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

	let res0 = UTShellCommand(console: console)
	let res1 = UTTranslator(console: console)

	if res0 && res1 {
		console.print(string: "Summary: OK\n")
	} else {
		console.print(string: "Summary: NG\n")
	}
}

main()

