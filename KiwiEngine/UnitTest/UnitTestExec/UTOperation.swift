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
	let operation = KEOperation(context: context, process: process, arguments: [])
	let queue     = OperationQueue()
	queue.addOperation(operation)

	queue.waitUntilAllOperationsAreFinished()

	var result = false
	let cntref = context.objectForKeyedSubscript("counter")
	if let cntval = cntref  {
		if cntval.isNumber {
			cons.print(string: "counter = \(cntval.description)\n")
			if cntval.toInt32() == 1 {
				result = true
			}
		} else {
			cons.error(string: "[Error] Invalid value \(cntval.description)\n")
		}
	} else {
		cons.error(string: "[Error] No result\n")
	}

	if result {
		cons.print(string: "testOperation: OK\n")
	} else {
		cons.print(string: "testOperation: NG\n")
	}

	return result
}

/*
public func testOperation(console cons: CNConsole, config conf: KEConfig) -> Bool
{
	cons.print(string: "*** Start testOperation\n")
	let vm         = JSVirtualMachine()!
	guard let operation0 = allocateOperation(virtualMachine: vm, console: cons, config: conf) else {
		return false
	}

	cons.print(string: "Enter operation into queue\n")
	let queue = OperationQueue()

	/* 1st execution */
	queue.addOperation(operation0)
	cons.print(string: "Wait until finished\n")
	waitUntilFinished(operation: operation0)
	printResult(operation: operation0, console: console)

	#if false
	/* 2nd execution */
	queue.addOperation(operation0)
	cons.print(string: "Wait until finished\n")
	waitUntilFinished(operation: operation0)
	printResult(operation: operation0, console: console)
	#endif
	
	cons.print(string: "Bye: OK\n")
	return true
}

private func allocateOperation(virtualMachine vm: JSVirtualMachine, console cons: CNConsole, config conf: KEConfig) -> KEOperation?
{
	let operation = KEOperation(virtualMachine: vm, console: console, config: conf)
	if operation.compile(fileName: "../UnitTest/UnitTestExec/UTOperation.js") {
		if operation.setStartup(mainName: "main", arguments: []) {
			return operation
		} else {
			cons.print(string: "[Error] user functions is not found.\n")
		}
	} else {
		cons.print(string: "[Error] Failed to compile\n")
	}
	return nil
}

private func waitUntilFinished(operation op: KEOperation)
{
	#if true
	op.waitUntilFinished()
	#else
	var docont = true
	while(docont){
		if(op.isFinished){
			docont = false
		}
	}
	#endif
}

private func printResult(operation op: KEOperation, console cons: CNConsole)
{
	if let resval = op.result {
		cons.print(string: "Result = \(resval.description)\n")
	} else {
		cons.print(string: "Result = nil\n")
	}
}

*/

