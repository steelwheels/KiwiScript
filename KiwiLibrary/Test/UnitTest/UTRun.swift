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
	let instrm:	CNFileStream	 = .fileHandle(cons.inputHandle)
	let outstrm:	CNFileStream	 = .fileHandle(cons.outputHandle)
	let errstrm:	CNFileStream	 = .fileHandle(cons.errorHandle)
	let env:	CNEnvironment	 = CNEnvironment()

	let arg0	= JSValue(int32: 123, in: ctxt)
	let arg1	= JSValue(object: "Message from UTRun", in: ctxt)
	guard let args  = JSValue(object: [arg0, arg1], in: ctxt) else {
		cons.print(string: "[Error] Failed to allocate arguments\n")
		return false
	}



	switch CNFilePath.URLForBundleFile(bundleName: "UnitTestBundle", fileName: "sample-1", ofType: "js") {
	case .ok(let url):
		let config    = KEConfig(applicationType: .terminal, doStrict: true, logLevel: .defaultLevel)
		let threadobj = KLThreadObject(scriptURL: url, processManager: manager, input: instrm, output: outstrm, error: errstrm, environment: env, config: config)
		let thread    = KLThread(thread: threadobj)
		thread.start(args)
		/* Wait until exist */
		let ecode = thread.waitUntilExit()
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

