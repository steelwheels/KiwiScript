/*
 * @file	UTRun.swift
 * @brief	Unit test for KLThread class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import KiwiLibrary
import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

public func UTRun(context ctxt: KEContext, console cons: CNFileConsole) -> Bool
{
	let manager:	CNProcessManager = CNProcessManager()
	let infile:	CNFile		 = cons.inputFile
	let outfile:	CNFile	 	 = cons.outputFile
	let errfile:	CNFile		 = cons.errorFile
	let terminfo:	CNTerminalInfo	 = CNTerminalInfo(width: 80, height: 25)
	let env:	CNEnvironment	 = CNEnvironment()

	let arg0	= JSValue(int32: 123, in: ctxt)
	let arg1	= JSValue(object: "Message from UTRun", in: ctxt)
	guard let args  = JSValue(object: [arg0, arg1], in: ctxt) else {
		cons.print(string: "[Error] Failed to allocate arguments\n")
		return false
	}

	switch CNFilePath.URLForBundleFile(bundleName: "UnitTest", fileName: "sample-1", ofType: "js") {
	case .ok(let url):
		let config = KEConfig(applicationType: .terminal, doStrict: true, logLevel: .defaultLevel)
		let thread = KLThread(source: .script(url), processManager: manager, input: infile, output: outfile, error: errfile, terminalInfo: terminfo, environment: env, config: config)
		thread.start(args)
		/* Wait until exist */
		var dowait = true
		while dowait {
			let val = thread.isRunning
			if val.isBoolean {
				dowait = val.toBool()
			} else {
				cons.print(string: "[Error] Invalid data type\n")
			}
		}
		let ecode = thread.exitCode.toInt32()
		cons.print(string: "Thread is finished with error code: \(ecode)\n")
	case .error(let err):
		cons.print(string: "[Error] \(err.toString())")
		return false
	@unknown default:
		cons.print(string: "[Error] Unsupported result")
		return false
	}

	return true
}

