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
	let console = CNFileConsole()

	let intf  = CNShellInterface()
	intf.output.setReader(handler: {
		(_ str: String) -> Void in
		console.print(string: str)
	})
	intf.error.setReader(handler: {
		(_ str: String) -> Void in
		console.error(string: str)
	})

	guard let vm = JSVirtualMachine() else {
		console.error(string: "Failed to allocate VM\n")
		return 
	}

	let env      = CNShellEnvironment()
	let config   = KEConfig(kind: .Terminal, doStrict: true, doVerbose: true)
	let context  = KEContext(virtualMachine: vm)
	let compiler = KHShellCompiler()
	guard compiler.compile(context: context, environment: env, console: console, config: config) else {
		console.error(string: "Failed to compiler\n")
		return
	}

	let shell   = KHShell(context: context, shellInterface: intf, environment: env, console: console, config: config)
	shell.start()

	sleep(1)

	var docont = true
	while docont {
		docont = !shell.isExecuting
	}
	
	console.print(string: "[Bye]\n")
}

main()

