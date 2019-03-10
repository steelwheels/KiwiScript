/*
 * @file	UTOperation.swift
 * @brief	Unit test for KLOperation class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import KiwiLibrary
import CoconutData
import JavaScriptCore
import Foundation

public func UTOperation(console cons: CNConsole, config conf: KLConfig) -> Bool
{
	cons.print(string: "// Allocate operation\n")
	guard let op = allocateOperation(console: cons, config: conf) else {
		cons.error(string: "Could not allocate operation\n")
		return false
	}
	cons.print(string: "// Execute the operation\n")
	let context = op.context
	let queue   = KLOperationQueue()
	let opval   = JSValue(object: op, in: context)
	let limval  = JSValue(nullIn: context)
	let retval  = queue.execute(opval!, limval!)
	guard retval.isBoolean && retval.toBool() else {
		cons.error(string: "Failed to execute operation\n")
		return false
	}

	cons.print(string: "// Wait operations are finished\n")
	queue.waitOperations()

	cons.print(string: "// Check output parameter\n")
	let outstr: String
	if let s = op.outputParameter.toString() {
		outstr = s
	} else {
		outstr = "<null>"
	}
	cons.print(string: "Result = \(outstr)\n")
	
	return true
}

private func allocateOperation(console cons: CNConsole, config conf: KLConfig) -> KLOperation?
{
	let op = KLOperation(console: cons, config: conf)

	
	let maindecl =  "function(){\n" +
			"  Operation.output = 5678 ; \n" +
			"  console.log(\"[MainFunc] \" + Operation.input + \", \" + Operation.output + \"\\n\") ;\n" +
			"}"
	let program  = JSValue(object: "console.log(\"***** Program *****\\n\");\n", in: op.context)
	let mainfunc = JSValue(object: maindecl, in: op.context)

	/* Set input parameter */
	op.inputParameter = JSValue(int32: 1234, in: op.context)

	let retval   = op.compile(program!, mainfunc!)
	guard retval.isBoolean && retval.toBool() else {
		cons.error(string: "Failed to compile operation\n")
		return nil
	}
	
	return op
}

