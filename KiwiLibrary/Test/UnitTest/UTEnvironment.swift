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
	ctxt.evaluateScript("Env.set(\"MSG\", \"hello\") ; env0 = Env.get(\"MSG\") ;")
	if let val = ctxt.getValue(name: "env0") {
		cons.print(string: "Env(MSG) = " + val.toString() + "\n")
	} else {
		cons.print(string: "[Error] No environment value\n")
		result = false
	}
	return result
}

