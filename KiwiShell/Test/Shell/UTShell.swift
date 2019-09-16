/**
 * @file	UTShell.swift
 * @brief	Test function for shell thread
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import KiwiShell
import KiwiEngine
import KiwiLibrary
import CoconutData
import CoconutShell
import JavaScriptCore
import Foundation

public func UTShell(input inhdl: FileHandle, output outhdl: FileHandle, error errhdl: FileHandle, console cons: CNConsole) -> Bool
{
	/* Set output listenner */
	outhdl.readabilityHandler = {
		(_ hdl: FileHandle) -> Void in
		cons.print(string: hdl.availableString)
	}

	guard let vm = JSVirtualMachine() else {
		cons.error(string: "Failed to allocate VM\n")
		return false
	}

	let env     = CNShellEnvironment()
	let config  = KEConfig(kind: .Terminal, doStrict: true, doVerbose: true)
	let shell   = KHShellThread(virtualMachine: vm, input: inhdl, output: outhdl, error: errhdl, environment: env, config: config)
	shell.start()

	sleep(1)

	//var docont = true
	//while docont {
	//	docont = !shell.isExecuting
	//}

	shell.cancel()
	cons.print(string: "[Bye]\n")

	return true
}

