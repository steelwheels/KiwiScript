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
import JavaScriptCore
import Foundation

public func main()
{
	let config  = KLConfig(kind: .Terminal, doStrict: true, doVerbose: true)
	config.doStrict  = true
	config.doVerbose = true

	let console = CNFileConsole()
	let context = KEContext(virtualMachine: JSVirtualMachine())
	let compiler = KLCompiler(console: console, config: config)
	let process  = KEProcess(context: context, config: config)
	guard compiler.compile(context: context, process: process) else {
		console.error(string: "Compilation was failed.\n")
		return
	}

	let shell    = KHShellConsole(context: context, console: console)
	let result   = shell.repl()
	print(" -> result = \(result)")

	console.print(string: "[Bye]\n")
}

main()

/*
import KiwiShell


let args    = CommandLine.arguments
let appname = args[0]
print("Hello, World! from \(appname)")

guard let vm = JSVirtualMachine() else {
	fatalError("Could not allocate VM")
}

let application = KMApplication(kind: .Terminal)
//application.name = appname



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



