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

private enum Command: Int {
	case setInput		= 0
	case getOutput		= 1

	public func toValue(context ctxt: KEContext) -> JSValue {
		return JSValue(int32: Int32(self.rawValue), in: ctxt)
	}
}

public func UTOperation(context ctxt: KEContext, console cons: CNConsole, config conf: KEConfig) -> Bool
{
	cons.print(string: "// Allocate operation\n")
	guard let op = allocateOperation(context: ctxt, console: cons, config: conf) else {
		cons.error(string: "Could not allocate operation\n")
		return false
	}

	cons.print(string: "// Set input\n")
	if let inval = JSValue(double: 1.23, in: ctxt) {
		op.set(Command.setInput.toValue(context: ctxt), inval)
	} else {
		cons.error(string: "Could not allocate input value\n")
		return false
	}

	cons.print(string: "// Execute the operation\n")
	let queue   = KLOperationQueue(console: cons)
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

private func allocateOperation(context ctxt: KEContext, console cons: CNConsole, config conf: KEConfig) -> KLOperation?
{
	let op       = KLOperation(ownerContext: ctxt, console: cons, config: conf)
	let script   =
		"class Task extends Operation\n" +
		"{\n" +
		"  main(){ console.log(\"Hello, World !!\\n\") ;}\n" +
		"}\n" +
		"operation = new Task() ;\n"
	let program  = JSValue(object: script, in: ctxt)

	let retval   = op.compile(program!)
	guard retval.isBoolean && retval.toBool() else {
		cons.error(string: "Failed to compile operation\n")
		return nil
	}
	
	return op
}

