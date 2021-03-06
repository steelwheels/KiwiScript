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

	let instrm  : CNFileStream = .fileHandle(inhdl)
	let outstrm : CNFileStream = .fileHandle(outhdl)
	let errstrm : CNFileStream = .fileHandle(errhdl)

	let procmgr  = CNProcessManager()
	let env      = CNEnvironment()
	let resource = KEResource(baseURL: URL(fileURLWithPath: "."))
	let config   = KEConfig(applicationType: .terminal, doStrict: true, logLevel: .detail)
	let shellobj = KHShellThreadObject(processManager: procmgr, input: instrm, output: outstrm, error: errstrm, externalCompiler: nil, environment: env, resource: resource, config: config)
	let shell    = KHShellThread(thread: shellobj)
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

