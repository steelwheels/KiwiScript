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

public class UTOperationObserver: NSObject
{
	private var mName	: String
	private var mConsole	: CNConsole

	public var isExecuting	: Bool
	public var isFinished	: Bool

	public init(name nm: String, console cons: CNConsole){
		mName 		= nm
		mConsole	= cons
		isExecuting	= false
		isFinished	= false
	}

	public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if let key = keyPath {
			if key == KEOperation.ExecutingItem {
				if let op = object as? KEOperation {
					isExecuting = op.isExecuting
				} else {
					mConsole.print(string: "Observer\(mName): isExecuting=\(String(describing: object))\n")
				}
			} else if key == KEOperation.FinishedItem {
				if let op = object as? KEOperation {
					isFinished = op.isFinished
				} else {
					mConsole.print(string: "Observer\(mName): isFinished=\(String(describing: object))\n")
				}
			} else {
				mConsole.print(string: "Observer\(mName): Unknown key: \(key)\n")
			}
		}
	}

	public func print(){
		mConsole.print(string: "\(mName): isExecuting=\(isExecuting), isFinished=\(isFinished)\n")
	}
}

public func testOperation(console cons: CNConsole) -> Bool
{
	let vm         = JSVirtualMachine()
	let context1    = KEContext(virtualMachine: vm!)
	context1.exceptionCallback = {
		(_ result: KEException) -> Void in
		console.print(string: result.description + "\n")
	}
	let context2    = KEContext(virtualMachine: vm!)
	context2.exceptionCallback = {
		(_ result: KEException) -> Void in
		console.print(string: result.description + "\n")
	}

	let operation1  = KEOperation(context: context1, script: "var a = 1 ;")
	let operation2  = KEOperation(context: context2, script: "for(var b=1 ; b<100 ; b++){}")
	let observer1   = UTOperationObserver(name: "1", console: cons)
	let observer2	= UTOperationObserver(name: "2", console: cons)

	operation1.add(observer: observer1)
	operation2.add(observer: observer2)

	let mqueue = OperationQueue()
	mqueue.addOperation(operation1)
	mqueue.addOperation(operation2)
	mqueue.maxConcurrentOperationCount = 2

	//console.print(string: "Wait until all operations are finished ... Start\n")
	mqueue.waitUntilAllOperationsAreFinished()
	//console.print(string: "Wait until all operations are finished ... Done\n")
	observer1.print()
	observer2.print()
	
	/* Wait until KVO print */
	sleep(1) ;

	return true ;
}
