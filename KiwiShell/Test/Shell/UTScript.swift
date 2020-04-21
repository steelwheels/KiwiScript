/**
 * @file	UTScript.swift
 * @brief	Test function for KHScriptThread class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

import KiwiShell
import KiwiLibrary
import KiwiEngine
import CoconutData
import CoconutShell
import JavaScriptCore
import Foundation

public func UTScript(input inhdl: FileHandle, output outhdl: FileHandle, error errhdl: FileHandle, console cons: CNConsole) -> Bool
{
	var result = true

	guard let vm = JSVirtualMachine() else {
		cons.error(string: "Failed to allocate VM\n")
		return false
	}

	let instrm  : CNFileStream = .fileHandle(inhdl)
	let outstrm : CNFileStream = .fileHandle(outhdl)
	let errstrm : CNFileStream = .fileHandle(errhdl)

	let script: String = "for(let i=0; i<1000000 ; i ++) { sleep(0.1) ; } "

	let procmgr  = CNProcessManager()
	let queue    = DispatchQueue(label: "UTShell", qos: .default, attributes: .concurrent)
	let env      = CNEnvironment()
	let resource = KEResource(baseURL: URL(fileURLWithPath: "."))
	let config   = KHConfig(applicationType: .terminal, hasMainFunction: false, doStrict: true, logLevel: .warning)
	let thread   = KHScriptThreadObject(virtualMachine: vm, script: .script(script), processManager: procmgr, queue: queue, input: instrm, output: outstrm, error: errstrm, environment: env, resource: resource, config: config)

	/* Execute the thread */
	thread.start(arguments: [])

	/* Check status */
	Thread.sleep(forTimeInterval: 1.0)
	if !thread.isRunning {
		cons.print(string: "Thread is NOT running\n")
		result = false
	}

	/* Terminate */
	thread.terminate()

	/* Check status */
	Thread.sleep(forTimeInterval: 0.5)
	if thread.isRunning {
		cons.print(string: "Thread is still running\n")
		result = false
	}

	return result
}

