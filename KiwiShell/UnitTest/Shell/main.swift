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
	let config  = KEConfig(kind: .Terminal, doStrict: true, doVerbose: true)
	let console = CNFileConsole()
	let context = KEContext(virtualMachine: JSVirtualMachine())
	let compiler = KLCompiler()
	guard compiler.compile(context: context, console: console, config: config) else {
		NSLog("Failed to compile")
		return
	}

	let intf  = CNShellInterface()
	intf.output.setReader(handler: {
		(_ str: String) -> Void in
		console.print(string: str)
	})
	intf.error.setReader(handler: {
		(_ str: String) -> Void in
		console.error(string: str)
	})

	let shell = KHShell(shellInterface: intf, console: console)
	shell.start()

	sleep(1)

	var docont = true
	while docont {
		docont = !shell.isExecuting
	}
	
	console.print(string: "[Bye]\n")
}

main()

