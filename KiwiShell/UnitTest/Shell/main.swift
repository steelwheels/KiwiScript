/**
 * @file	main.swift
 * @brief	Main function of shell test
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiShell
import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

let args    = CommandLine.arguments
let appname = args[0]
print("Hello, World! from \(appname)")

guard let vm = JSVirtualMachine() else {
	fatalError("Could not allocate VM")
}

let application = KEApplication(kind: .Terminal)
application.name = appname

let shell    = KHShellConsole(application: application)
let result   = shell.repl()
print(" -> result = \(result)")
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



