/*
 * @file	UTOperation.swift
 * @brief	Unit test for KEOperation class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

public func testOperation(console cons: CNConsole, config conf: KEConfig) -> Bool
{
	let context = KEContext(virtualMachine: JSVirtualMachine())
	let process = KEOperationProcess(context: context)

	cons.print(string: "/*** Compile Operation ***/\n")
	let srcurl = URL(fileURLWithPath: "../UnitTest/UnitTestExec/UTOperation.js")
	let compiler = KEOperationCompiler(console: cons, config: conf)
	guard compiler.compile(context: context, process: process, sourceFiles: [srcurl]) else {
		return false
	}

	cons.print(string: "/*** Enqueue Operation ***/\n")
	let queue     = OperationQueue()

	/* 1st operation */
	let ctxt0 = KEOperationContext(context: context)
	let op0   = KEOperation(context: ctxt0, arguments: [])
	queue.addOperation(op0)
	queue.waitUntilAllOperationsAreFinished()
	guard let counter0 = getCounter(context: context, console:cons) else {
		cons.print(string: "[Error] No counter value\n")
		return false
	}
	if counter0 == 1 {
		cons.print(string: "1st operation ... OK\n")
	} else {
		cons.print(string: "[Error] Unexpected counter value\n")
		return false
	}
	if let code = op0.exitCode {
		if code != .NoError {
			cons.print(string: "Error: \(code.description)\n")
			return false
		}
	} else {
		cons.print(string: "No exit code.\n")
		return false
	}

	/* 2nd operation */
	let ctxt1 = KEOperationContext(context: context)
	let op1   = KEOperation(context: ctxt1, arguments: [])
	queue.addOperation(op1)
	queue.waitUntilAllOperationsAreFinished()
	guard let counter1 = getCounter(context: context, console:cons) else {
		cons.print(string: "[Error] No counter value\n")
		return false
	}
	if counter1 == 2 {
		cons.print(string: "2nd operation ... OK\n")
	} else {
		cons.print(string: "[Error] Unexpected counter value\n")
		return false
	}
	if let code = op1.exitCode {
		if code != .NoError {
			cons.print(string: "Error: \(code.description)\n")
			return false
		}
	} else {
		cons.print(string: "No exit code.\n")
		return false
	}

	return true
}

private func getCounter(context ctxt: KEContext, console cons: CNConsole) -> Int32?
{
	let cntref = ctxt.objectForKeyedSubscript("counter")
	if let cntval = cntref  {
		if cntval.isNumber {
			cons.print(string: "counter = \(cntval.description)\n")
			return cntval.toInt32()
		} else {
			cons.error(string: "[Error] Invalid value \(cntval.description)\n")
		}
	} else {
		cons.error(string: "[Error] No result\n")
	}
	return nil
}

