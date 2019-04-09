/**
 * @file	KLOperationQueue.swift
 * @brief	Define KLOperationQueue class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

@objc public protocol KLOperationQueueProtocol: JSExport
{
	func execute(_ operation: JSValue, _ timelimit: JSValue) -> JSValue
	func waitOperations()
	var operationCount: JSValue { get }
}

@objc public class KLOperationQueue: NSObject, KLOperationQueueProtocol
{
	private var mContext:	KEContext
	private var mQueue: 	CNOperationQueue
	private var mConsole:	CNConsole

	public init(context ctxt: KEContext, console cons: CNConsole) {
		mContext = ctxt
		mQueue   = CNOperationQueue()
		mConsole = cons
	}

	public func execute(_ operation: JSValue, _ timelimit: JSValue) -> JSValue {
		let result: Bool
		if let op = valueToOperation(operation: operation) {
			let limit  = valueToInterval(time: timelimit)
			result = mQueue.execute(operations: [op.shiftOutOperation()], timeLimit: limit)
		} else {
			mConsole.error(string: "Unexcected object (Operation object is required)\n")
			result = false
		}
		return JSValue(bool: result, in: mContext)
	}

	public func waitOperations() {
		mQueue.waitOperations()
	}

	public var operationCount: JSValue {
		get {
			let count = mQueue.operationCount
			return JSValue(int32: Int32(count), in: mContext)
		}
	}

	private func valueToOperation(operation opval: JSValue) -> KLOperation? {
		if opval.isObject {
			if let op = opval.toObject() as? KLOperation {
				return op
			}
		}
		return nil
	}

	private func valueToInterval(time tm: JSValue) -> TimeInterval? {
		if tm.isNumber {
			return TimeInterval(tm.toDouble())
		}
		return nil
	}
}

