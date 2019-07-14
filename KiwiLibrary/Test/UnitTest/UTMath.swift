/*
 * @file	UTMath.swift
 * @brief	Test math functions
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import Foundation

public func UTMath(context ctxt: KEContext, console cons: CNConsole) -> Bool
{
	var 	result = true

	/* sqrt */
	ctxt.evaluateScript("eval0 = sqrt(4.0) ;")
	if let resval = ctxt.getValue(name: "eval0") {
		cons.print(string: "sqrt(4.0) = \(resval.toDouble())\n")
	} else {
		cons.error(string: "Failed to execute sqrt\n")
		result = false
	}

	return result
}

