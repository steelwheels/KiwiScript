/*
 * @file	UTOperationQueues.swift
 * @brief	Unit test for KEOperationQueues class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import Foundation

public func testOperationQueues(console cons: CNConsole) -> Bool
{
	let conf  = KEConfig(kind: .Operation, doStrict: true, doVerbose: false)
	let qnum  = 2
	let opnum = 4

	/* Allocate cotexts */
	typealias  OperationContext = KEOperationQueues.OperationContext
	var ctxtgroups: Array<Array<OperationContext>> = []
	for _ in 0..<qnum {
		var ctxtgroup: Array<OperationContext> = []
		for _ in 0..<opnum {
			let (ctxt, proc) = allocateContext(console: cons, config: conf)
			let opctxt = OperationContext(context: ctxt, process: proc)
			ctxtgroup.append(opctxt)
		}
		ctxtgroups.append(ctxtgroup)
	}

	let queues = KEOperationQueues(queueNum: qnum)

	queues.execute(contextGroups: ctxtgroups, timeLimit: nil)
	let result0 = checkResult(expectedValue: 1, contextGroups: ctxtgroups, console: cons)

	queues.execute(contextGroups: ctxtgroups, timeLimit: nil)
	let result1 = checkResult(expectedValue: 2, contextGroups: ctxtgroups, console: cons)

	let result = result0 && result1
	if result {
		cons.print(string: "\(#function) ... OK\n")
	} else {
		cons.print(string: "\(#function) ... NG\n")
	}
	return result
}

private func checkResult(expectedValue expval: Int, contextGroups groups: Array<Array<KEOperationQueues.OperationContext>>, console cons: CNConsole) -> Bool
{
	var result = true
	for group in groups {
		for op in group {
			if let cnt = getCounter(context: op.context, console: cons) {
				if expval != cnt {
					cons.error(string: "[Error] Expect value \(result) but \(cnt) is given\n")
					result = false
				}
			} else {
				cons.error(string: "[Error] No counter variable\n")
				result = false
			}
		}
	}
	return result
}

