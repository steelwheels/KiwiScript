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

	/* asin */
	ctxt.evaluateScript("eval1 = asin(1.0/1.41421) ;")
	if let resval = ctxt.getValue(name: "eval1") {
		let res = resval.toDouble() / Double.pi
		let rnd = round(res * 100.0) / 100.0
		cons.print(string: "asin(1.0/1.41421) = \(rnd)PI\n")
	} else {
		cons.error(string: "Failed to execute asin\n")
		result = false
	}

	/* acos */
	ctxt.evaluateScript("eval2 = acos(1.41421/2.0) ;")
	if let resval = ctxt.getValue(name: "eval2") {
		let res = resval.toDouble() / Double.pi
		let rnd = round(res * 100.0) / 100.0
		cons.print(string: "acos(1.41421/2.0) = \(rnd)PI\n")
	} else {
		cons.error(string: "Failed to execute acos\n")
		result = false
	}

	return result
}

