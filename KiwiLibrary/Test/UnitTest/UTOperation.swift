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

public func UTOperation(context ctxt: KEContext, console cons: CNConsole, config conf: KLConfig) -> Bool
{
	cons.print(string: "// Allocate operation\n")
	guard let op = allocateOperation(context: ctxt, console: cons, config: conf) else {
		cons.error(string: "Could not allocate operation\n")
		return false
	}
	cons.print(string: "// Execute the operation\n")
	let queue   = KLOperationQueue()
	let opval   = JSValue(object: op, in: ctxt)
	let limval  = JSValue(nullIn: ctxt)
	let retval  = queue.execute(opval!, limval!)
	guard retval.isBoolean && retval.toBool() else {
		cons.error(string: "Failed to execute operation\n")
		return false
	}

	cons.print(string: "// Wait operations are finished\n")
	queue.waitOperations()

	cons.print(string: "// Check output parameter\n")
	let outstr: String
	if let s = op.output.toString() {
		outstr = s
	} else {
		outstr = "<null>"
	}
	cons.print(string: "Result = \(outstr)\n")
	
	return true
}

private func allocateOperation(context ctxt: KEContext, console cons: CNConsole, config conf: KLConfig) -> KLOperation?
{
	let op = KLOperation(ownerContext: ctxt, console: cons, config: conf)

	let maindecl =  "function(){\n" +
			"  Operation.output = 5678 ; \n" +
			"  console.log(\"[MainFunc] \" + Operation.input + \", \" + Operation.output + \"\\n\") ;\n" +
			"}"
	let program  = JSValue(object: "console.log(\"***** Program *****\\n\");\n", in: ctxt)
	let mainfunc = JSValue(object: maindecl, in: ctxt)

	/* Set input parameter */
	op.input = JSValue(int32: 1234, in: ctxt)

	let retval   = op.compile(program!, mainfunc!)
	guard retval.isBoolean && retval.toBool() else {
		cons.error(string: "Failed to compile operation\n")
		return nil
	}
	
	return op
}

