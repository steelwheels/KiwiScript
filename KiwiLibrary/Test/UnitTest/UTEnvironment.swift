/*
 * @file	UTEnvironment.swift
 * @brief	Unit test for "Env" class object
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import Foundation

public func UTEnvironment(context ctxt: KEContext, console cons: CNFileConsole) -> Bool
{
	var result = true

	/* Set and get */
	ctxt.evaluateScript("Environment.set(\"MSG\", \"hello\") ; env0 = Environment.get(\"MSG\") ;")
	if let val = ctxt.getValue(name: "env0") {
		cons.print(string: "Environment(\"MSG\") = " + val.toString() + "\n")
	} else {
		cons.print(string: "[Error] No environment value\n")
		result = false
	}

	/* currentDirectory */
	let scr0 =   "let curdir = Environment.currentDirectory ; \n"
		   + "console.log(\"current_directory => \" + isString(curdir.path)) ;"
	ctxt.evaluateScript(scr0)

	/* temporaryDirectory */
	let scr1 =   "let tmpdir = Environment.temporaryDirectory ; \n"
		   + "console.log(\"temporary_directory => \" + isString(tmpdir.path)) ;"
	ctxt.evaluateScript(scr1)

	return result
}

