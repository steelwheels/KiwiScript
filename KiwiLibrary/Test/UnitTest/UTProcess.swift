/*
 * @file	UTProcess.swift
 * @brief	Unit test for Process classes
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import KiwiLibrary
import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

public func UTProcess(context ctxt: KEContext, console cons: CNFileConsole) -> Bool
{
	return UTSemaphore(context: ctxt, console: cons)
}

private func UTSemaphore(context ctxt: KEContext, console cons: CNFileConsole) -> Bool
{
	let stmt =   "let sem = new Semaphore(0) ; "
		   + "sem.signal() ;\n"
	           + "console.log(\"between semaphore\") ;"
		   + "sem.wait() ;\n"
	if let res = ctxt.evaluateScript(stmt) {
		cons.print(string: "Semaphore result = \(res.description)\n")
		return true
	} else {
		cons.print(string: "Semaphore result = null\n")
		return false
	}
}
