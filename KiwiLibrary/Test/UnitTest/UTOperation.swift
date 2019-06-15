/*
 * @file	UTOperation.swift
 * @brief	Unit test for KLOperation class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import KiwiLibrary
import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

public func UTOperation(context ctxt: KEContext, console cons: CNConsole, config conf: KEConfig) -> Bool
{
	cons.print(string: "// Allocate operation\n")
	guard let op = allocateOperation(context: ctxt, console: cons, config: conf) else {
		cons.error(string: "Could not allocate operation\n")
		return false
	}

	cons.print(string: "// Set input\n")
	if let inval = JSValue(double: 1.23, in: ctxt) {
		op.setParameter(JSValue(object: "input", in: ctxt), inval)
	} else {
		cons.error(string: "Could not allocate input value\n")
		return false
	}

	cons.print(string: "// Get input\n")
	let outval = op.parameter(JSValue(object: "input", in: ctxt))
	if outval.isNumber {
		let val = outval.toDouble()
		if val == 1.23 {
			cons.error(string: "Input value: \(val)\n")
		} else {
			cons.error(string: "Input value is not 1.23\n")
			return false
		}
	} else {
		cons.error(string: "Could not get input value: \"\(outval.description)\"\n")
		return false
	}

	cons.print(string: "// Execute the operation\n")
	let queue   = KLOperationQueue(context: ctxt, console: cons)
	let opval   = JSValue(object: op, in: ctxt)
	let limval  = JSValue(nullIn: ctxt)
	let retval  = queue.execute(opval!, limval!)
	guard retval.isBoolean && retval.toBool() else {
		cons.error(string: "Failed to execute operation\n")
		return false
	}

	cons.print(string: "// Wait operations are finished\n")
	queue.waitOperations()

	//cons.print(string: "// Check output parameter\n")
	//let outstr: String
	//if let s = op.output.toString() {
	//	outstr = s
	//} else {
	//	outstr = "<null>"
	//}
	//cons.print(string: "Result = \(outstr)\n")
	
	return true
}

private func allocateOperation(context ctxt: KEContext, console cons: CNConsole, config conf: KEConfig) -> KLOperationContext?
{
	let op     = KLOperationContext(ownerContext: ctxt, console: cons, config: conf)
	let (urlp, errorp) = CNFilePath.URLForBundleFile(bundleName: "UnitTest", fileName: "unit-test-0", ofType: "js")
	if let url = urlp {
		if op.compile(userScripts: [url]) {
			return op
		} else {
			cons.error(string: "Failed to compile operation\n")
		}
	} else if let err = errorp {
		cons.error(string: "[Error] \(err.description)")
	}
	return nil
}

