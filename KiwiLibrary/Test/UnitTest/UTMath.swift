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

	/* sin */
	ctxt.evaluateScript("eval0 = Math.sin(PI/2.0) ;")
	if let resval = ctxt.get(name: "eval0") {
		cons.print(string: "Math.sin(PI/2.0) = \(resval.toDouble())\n")
	} else {
		cons.error(string: "Failed to execute Math.sin\n")
		result = false
	}

	/* cos */
	ctxt.evaluateScript("eval1 = Math.cos(PI/2.0) ;")
	if let resval = ctxt.get(name: "eval1") {
		cons.print(string: "Math.cos(PI/2.0) = \(resval.toDouble())\n")
	} else {
		cons.error(string: "Failed to execute Math.cos\n")
		result = false
	}

	/* tan */
	ctxt.evaluateScript("eval2 = Math.tan(PI/4.0) ;")
	if let resval = ctxt.get(name: "eval2") {
		cons.print(string: "Math.tan(PI/4.0) = \(resval.toDouble())\n")
	} else {
		cons.error(string: "Failed to execute Math.tan\n")
		result = false
	}

	/* asin */
	ctxt.evaluateScript("eval3 = Math.asin(1.0/1.41421) ;")
	if let resval = ctxt.get(name: "eval3") {
		let res = resval.toDouble() / Double.pi
		let rnd = round(res * 100.0) / 100.0
		cons.print(string: "Math.asin(1.0/1.41421) = \(rnd)PI\n")
	} else {
		cons.error(string: "Failed to execute Math.asin\n")
		result = false
	}

	/* acos */
	ctxt.evaluateScript("eval4 = Math.acos(1.41421/2.0) ;")
	if let resval = ctxt.get(name: "eval4") {
		let res = resval.toDouble() / Double.pi
		let rnd = round(res * 100.0) / 100.0
		cons.print(string: "acos(1.41421/2.0) = \(rnd)PI\n")
	} else {
		cons.error(string: "Failed to execute Math.acos\n")
		result = false
	}

	/* sqrt */
	ctxt.evaluateScript("eval2 = Math.sqrt(4.0) ;")
	if let resval = ctxt.get(name: "eval2") {
		cons.print(string: "Math.sqrt(4.0) = \(resval.toDouble())\n")
	} else {
		cons.error(string: "Failed to execute sqrt\n")
		result = false
	}

	return result
}

