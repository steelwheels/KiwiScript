/*
 * @file	UTThread.swift
 * @brief	Unit test for KLThread class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import KiwiLibrary
import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

public func UTThread(context ctxt: KEContext, processManager procmgr: CNProcessManager, queue disque: DispatchQueue, console cons: CNFileConsole, config conf: KEConfig) -> Bool
{
	var result = false

	let pkgurl = URL(fileURLWithPath: "../Test/Sample/sample-0.jspkg")
	cons.print(string: "Source URL: \(pkgurl.absoluteString)\n")

	//cons.print(string: "Package: \(pkgurl.absoluteString)\n")

	let resource = KEResource(baseURL: pkgurl)
	let loader   = KEManifestLoader()
	if let err = loader.load(into: resource) {
		cons.error(string: "[Error] \(err.toString())\n")
		result = false
	} else {
		/* Dump the resource file */
		let text = resource.toText()
		text.print(console: cons)

		/* Allocate thread */
		guard let vm     = JSVirtualMachine() else {
			cons.print(string: "[Error] Failed to allocate VM\n")
			return false
		}

		let file:	KLThread.ScriptFile	= .identifier("sample0")
		let instrm: 	CNFileStream		= .fileHandle(cons.inputHandle)
		let outstrm:	CNFileStream		= .fileHandle(cons.outputHandle)
		let errstrm:	CNFileStream		= .fileHandle(cons.errorHandle)
		let terminfo:	CNTerminalInfo		= CNTerminalInfo(width: 80, height: 25)
		let env:     	CNEnvironment		= CNEnvironment()
		let config 			 = KEConfig(applicationType: .terminal, doStrict: true, logLevel: .defaultLevel)
		let threadobj = KLThreadObject(virtualMachine: vm, scriptFile: file, processManager: procmgr, queue: disque, input: instrm, output: outstrm, error: errstrm, terminalInfo: terminfo, environment: env, resource: resource, config: config)
		let thread    = KLThread(thread: threadobj)

		/* Start thread */
		let arg0   = JSValue(object: "Thread", in: ctxt)
		let arg1   = JSValue(int32: 123, in: ctxt)
		guard let args   = JSValue(object: [arg0, arg1], in: ctxt) else {
			cons.print(string: "[Error] Failed to allocate arguments\n")
			return false
		}
		thread.start(args)

		/* Wait until exist */
		let ecode = thread.waitUntilExit()
		cons.print(string: "Thread is finished with error code: \(ecode)\n")

		/* Test passed */
		result = (ecode == 0)
	}

	return result
}

