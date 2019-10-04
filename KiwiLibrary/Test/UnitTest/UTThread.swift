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

public func UTThread(context ctxt: KEContext, console cons: CNConsole, config conf: KEConfig) -> Bool
{
	var result = false

	let pkgurl = URL(fileURLWithPath: "../Test/Sample/sample-0.jspkg")
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
			cons.error(string: "[Error] Failed to allocate VM\n")
			return false
		}
		let inhdl  = FileHandle.standardInput
		let outhdl = FileHandle.standardOutput
		let errhdl = FileHandle.standardError
		let thread = KLThread(virtualMachine: vm, input: inhdl, output: outhdl, error: errhdl)

		/* Compile the thread */
		guard thread.compile(scriptName: "sample0", in: resource) else {
			cons.error(string: "[Error] Failed to compile\n")
			return false
		}

		/* Start thread */
		let arg0   = JSValue(object: "Thread", in: ctxt)
		let arg1   = JSValue(int32: 123, in: ctxt)
		guard let args   = JSValue(object: [arg0, arg1], in: ctxt) else {
			cons.error(string: "[Error] Failed to allocate arguments\n")
			return false
		}
		thread.start(args)

		/* Wait until exist */
		thread.waitUntilExit()

		/* Test passed */
		result = true
	}

	return result
}

