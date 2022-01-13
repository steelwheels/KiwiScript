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

public func UTThread(context ctxt: KEContext, processManager procmgr: CNProcessManager, console cons: CNFileConsole, config conf: KEConfig) -> Bool
{
	var result = false

	let pkgurl: URL
	switch CNFilePath.URLForBundleFile(bundleName: "UnitTest", fileName: "sample-0", ofType: "jspkg") {
	case .ok(let url):
		pkgurl = url
		cons.print(string: "Source URL: \(pkgurl.absoluteString)\n")
	case .error(let err):
		cons.print(string: "[Error] \(err.toString())\n")
		return result
	@unknown default:
		cons.print(string: "[Error] Unsupported result\n")
		return result
	}

	let resource = KEResource(packageDirectory: pkgurl)
	let loader   = KEManifestLoader()
	if let err = loader.load(into: resource) {
		cons.error(string: "[Error] \(err.toString())\n")
		result = false
	} else {
		/* Dump the resource file */
		let text = resource.toText().toStrings().joined(separator: "\n")
		cons.print(string: text + "\n")

		let infile: 	CNFile = cons.inputFile
		let outfile:	CNFile = cons.outputFile
		let errfile:	CNFile = cons.errorFile
		let terminfo:	CNTerminalInfo = CNTerminalInfo(width: 80, height: 25)
		let env:     	CNEnvironment  = CNEnvironment()
		let config   = KEConfig(applicationType: .terminal, doStrict: true, logLevel: .defaultLevel)

		guard let url = resource.URLOfThread(identifier: "sample0") else {
			return false
		}

		let thread   = KLThread(source: .script(url), processManager: procmgr, input: infile, output: outfile, error: errfile, terminalInfo: terminfo, environment: env, config: config)

		/* Start thread */
		let arg0   = JSValue(object: "Thread", in: ctxt)
		let arg1   = JSValue(int32: 123, in: ctxt)
		guard let args   = JSValue(object: [arg0, arg1], in: ctxt) else {
			cons.print(string: "[Error] Failed to allocate arguments\n")
			return false
		}
		thread.start(args)

		/* Wait until exist */
		var dowait = true
		while dowait {
			let val = thread.isRunning
			if val.isBoolean {
				dowait = val.toBool()
			} else {
				cons.print(string: "[Error] Invalid data type")
			}
		}
		let ecode = thread.exitCode.toInt32()
		cons.print(string: "Thread is finished with error code: \(ecode)\n")

		/* Test passed */
		result = (ecode == 0)
	}

	return result
}

