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
	let vm         = JSVirtualMachine()
	let operation0 = KEOperation(virtualMachine: vm!, console: console, config: conf)
	if operation0.compile(fileName: "../UnitTest/UnitTestExec/UTOperation.js") {
		return true
	} else {
		cons.print(string: "[Error] Failed to compile\n")
		return false
	}
}

/*
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

	let config   = KEConfig()
	//config.doVerbose = true

	let compiler = KECompiler(console: cons, config: config)
	guard compiler.compile(context: context1) else {
		console.print(string: "[Error] Compile failed (1)")
		return false
	}
	guard compiler.compile(context: context2) else {
		console.print(string: "[Error] Compile failed (2)")
		return false
	}

	let operation1  = KEOperation(context: context1, script: "function(){ return 0 ; }")
	let operation2  = KEOperation(context: context2, script: "function(){ return 1 ; }")
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
	sleep(1)
	observer1.print()
	observer2.print()

	return true ;
}
*/

