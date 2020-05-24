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

	guard let vm = JSVirtualMachine() else {
		cons.print(string: "Could not allocate VM")
		return false
	}
	let pkgurl 	= URL(fileURLWithPath: "../Test/Sample/sample-0.jspkg")
	let resource	= KEResource(baseURL: pkgurl)

	let arg0	= JSValue(int32: 123, in: ctxt)
	let arg1	= JSValue(object: "Message from UTRun", in: ctxt)
	guard let args  = JSValue(object: [arg0, arg1], in: ctxt) else {
		cons.print(string: "[Error] Failed to allocate arguments\n")
		return false
	}

	let config    = KEConfig(applicationType: .terminal, doStrict: true, logLevel: .defaultLevel)
	let url       = URL(fileURLWithPath: "../Test/Sample/sample-1.js")
	let threadobj = KLThreadObject(virtualMachine: vm, scriptFile: .url(url), processManager: manager, input: instrm, output: outstrm, error: errstrm, environment: env, resource: resource, config: config)
	let thread    = KLThread(thread: threadobj)
	thread.start(args)

	/* Wait until exist */
	let ecode = thread.waitUntilExit()
	cons.print(string: "Thread is finished with error code: \(ecode)\n")

	/* Test passed */
	return (ecode == 0)
}

