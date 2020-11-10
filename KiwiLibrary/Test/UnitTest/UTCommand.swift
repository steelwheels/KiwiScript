/*
 * @file	UTCommand.swift
 * @brief	Unit test for KLCommand class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

import KiwiLibrary
import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

public func UTCommand(context ctxt: KEContext, console cons: CNFileConsole, environment env: CNEnvironment) -> Bool
{
	let res0 = UTCdCommand(context: ctxt, console: cons, environment: env)
	return res0
}

private func UTCdCommand(context ctxt: KEContext, console cons: CNFileConsole, environment env: CNEnvironment) -> Bool
{
	var result = true

	let orgdir = env.currentDirectory
	cons.print(string: "Before execute cd command: curdir=\(orgdir.absoluteString) \n")

	/* Change directory to parent */
	let res0 = execCdCommand(context: ctxt, path: "..", cons: cons, environment: env)
	if res0 != 0 {
		cons.print(string: "[Error] cd is failed\n")
		result = false
	}

	/* Change directory to invalid directory */
	let res1 = execCdCommand(context: ctxt, path: "Hoge", cons: cons, environment: env)
	if res1 == 0 {
		cons.print(string: "[Error] cd is successed\n")
		result = false
	}

	/* Change directory to "Debug" directory */
	let res2 = execCdCommand(context: ctxt, path: "./Debug", cons: cons, environment: env)
	if res2 != 0 {
		cons.print(string: "[Error] cd is failed\n")
		result = false
	}

	/* Change directory to "Home" directory */
	let res3 = execCdCommand(context: ctxt, path: nil, cons: cons, environment: env)
	if res3 != 0 {
		cons.print(string: "[Error] cd is failed\n")
		result = false
	}

	return result
}

private func execCdCommand(context ctxt: KEContext, path pstr: String?, cons: CNFileConsole, environment env: CNEnvironment) -> Int32 {
	cons.print(string: "cd command: \(String(describing: pstr))\n")
	cons.print(string: "(prev) dir \(env.currentDirectory.absoluteString)\n")
	let cdparam = makeCdParameter(context: ctxt, path: pstr)
	let cdcmd   = KLCdCommand(context: ctxt, console: cons, environment: env)
	cdcmd.start(cdparam)
	let res = cdcmd.waitUntilExit()
	cons.print(string: " -> result \(res)\n")
	cons.print(string: "(after) dir \(env.currentDirectory.absoluteString)\n")
	return res
}

private func makeCdParameter(context ctxt: KEContext, path pstr: String?) -> JSValue {
	if let path = pstr {
		return JSValue(object: path, in: ctxt)
	} else {
		return JSValue(nullIn: ctxt)
	}
}
