/**
 * @file	main.swift
 * @brief	Main function of shell test
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiShell
import Canary
import Foundation

let args    = CommandLine.arguments
let appname = args[0]
print("Hello, World! from \(appname)")

let console  = CNFileConsole()
let shell    = KHShellConsole(applicationName: appname, console: console)
shell.repl()

/*
let editline = CNEditLine()
editline.setup(programName: "Shell", console: console)
editline.doBuffering = true

var input: String? = nil
while input == nil {
	if let instr = editline.gets() {
		input = instr
	}
}
print("input -> \(input!)")
*/



