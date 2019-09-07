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

	/* Set output listenner */
	outhdl.readabilityHandler = {
		(_ hdl: FileHandle) -> Void in
		console.print(string: hdl.availableString)
	}

	guard let vm = JSVirtualMachine() else {
		console.error(string: "Failed to allocate VM\n")
		return 
	}

	let env     = CNShellEnvironment()
	let config  = KEConfig(kind: .Terminal, doStrict: true, doVerbose: true)
	let shell   = KHShellThread(virtualMachine: vm, input: inhdl, output: outhdl, error: errhdl, environment: env, config: config)
	shell.start()

	sleep(1)

	var docont = true
	while docont {
		docont = !shell.isExecuting
	}
	
	console.print(string: "[Bye]\n")
}

main()

