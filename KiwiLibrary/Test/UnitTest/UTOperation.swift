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
	
	return true
}

private func allocateOperation(console cons: CNConsole, config conf: KLConfig) -> KLOperation?
{
	let op = KLOperation(console: cons, config: conf)

	let program  = JSValue(object: "console.log(\"***** Program *****\\n\");\n", in: op.context)
	let mainfunc = JSValue(object: "function(){ console.log(\"***** MainFunc *****\\n\"); }", in: op.context)
	let retval   = op.compile(program!, mainfunc!)
	guard retval.isBoolean && retval.toBool() else {
		cons.error(string: "Failed to compile operation\n")
		return nil
	}

	return op
}

