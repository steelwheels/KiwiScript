/**
 * @file	KLThread.swift
 * @brief	Define KLThread class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation

@objc public protocol KLThreadProtocol: JSExport {
	func start(_ args: JSValue)
	func isRunning() -> Bool
	func waitUntilExit()
	func exitCode() -> Int32
}

private class KLThreadObject: CNThread
{
	private var mContext:	KEContext
	private var mArguments:	Array<JSValue>
	private var mConsole:	CNFileConsole

	public init(virtualMachine vm: JSVirtualMachine, input inhdl: FileHandle, output outhdl: FileHandle, error errhdl: FileHandle) {
		mContext   = KEContext(virtualMachine: vm)
		mArguments = []
		mConsole   = CNFileConsole(input: inhdl, output: outhdl, error: errhdl)
		super.init(input: inhdl, output: outhdl, error: errhdl, terminationHander: {
			(_ thread: Thread) -> Int32 in
			return 0
		})
	}

	public func compile(scriptName name: String, in resource: KEResource) -> Bool {
		/* Compile */
		let compiler = KLCompiler()
		let config   = KEConfig(kind: .Terminal, doStrict: true, doVerbose: false)
		guard compiler.compile(context: mContext, console: mConsole, config: config) else {
			return false
		}
		guard compiler.compile(context: mContext, scriptName: name, resource: resource, console: mConsole, config: config) else {
			return false
		}
		return true
	}

	public func start(arguments args: JSValue) {
		mArguments = []
		let native = args.toNativeValue()
		switch native {
		case .arrayValue(let arr):
			for elm in arr {
				mArguments.append(elm.toJSValue(context: mContext))
			}
		default:
			mArguments.append(native.toJSValue(context: mContext))
		}
		super.start()
	}

	public override func mainOperation() -> Int32 {
		/* Search main function */
		var result: Int32 = 0
		if let funcval = mContext.getValue(name: "main") {
			if let retval = funcval.call(withArguments: mArguments) {
				result = retval.toInt32()
			} else {
				mConsole.error(string: "Failed to call main function")
				result = 1
			}
		} else {
			mConsole.error(string: "main function is NOT found.")
			result = 1
		}
		return result
	}
}

@objc public class KLThread: NSObject, KLThreadProtocol
{
	private var mThread: KLThreadObject

	public init(virtualMachine vm: JSVirtualMachine, input inhdl: FileHandle, output outhdl: FileHandle, error errhdl: FileHandle) {
		mThread = KLThreadObject(virtualMachine: vm, input: inhdl, output: outhdl, error: errhdl)
	}

	public func compile(scriptName name: String, in resource: KEResource) -> Bool {
		return mThread.compile(scriptName: name, in: resource)
	}

	public func start(_ args: JSValue) {
		mThread.start(arguments: args)
	}

	public func isRunning() -> Bool {
		let result: Bool
		switch mThread.status {
		case .Finished:		result = false
		case .Idle:		result = false
		case .Running:		result = true
		}
		return result
	}

	public func waitUntilExit() {
		mThread.waitUntilExit()
	}

	public func exitCode() -> Int32 {
		return mThread.terminationStatus
	}

	public func print(string str: String) {
		mThread.outputFileHandle.write(string: str)
	}

	public func error(string str: String) {
		mThread.errorFileHandle.write(string: str)
	}
}

