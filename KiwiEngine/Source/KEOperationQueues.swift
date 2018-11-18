/**
 * @file	KEOperationQueues.swift
 * @brief	Define KEOperationQueues class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KEOperationQueues: CNOperationQueues
{
	public struct OperationContext {
		public var	context : KEContext
		public var	process : KEProcess
		public init(context ctxt: KEContext, process proc: KEProcess){
			context = ctxt
			process = proc
		}
	}

	public func execute(contextGroups groups: Array<Array<OperationContext>>, timeLimit limit: TimeInterval?) {
		/* Allocate operations for each contexts */
		var opgroups: Array<Array<KEOperation>> = []
		for group in groups {
			var opgroup: Array<KEOperation> = []
			for ctxt in group {
				let operation = KEOperation(context: ctxt.context, process: ctxt.process, arguments: [])
				opgroup.append(operation)
			}
			opgroups.append(opgroup)
		}
		/* Execute */
		super.execute(operationGroups: opgroups, timeLimit: limit)
	}
}

