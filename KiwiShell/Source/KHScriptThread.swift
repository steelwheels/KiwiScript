/**
 * @file	KHScriptThread.swift
 * @brief	Define KHScriptThread class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutShell
import CoconutData
import KiwiEngine
import KiwiLibrary
import JavaScriptCore
import Foundation

@objc public protocol KHThreadProtocol: JSExport
{
	var  isExecuting: Bool { get }
	func start(_ args: JSValue)
	func waitUntilExit() -> Int32
}

public class KHScriptThreadObject: CNThread
{
	public enum Script {
		case empty
		case script(String)
		case file(URL)
	}

	private var mContext:			KEContext
	private var mChildProcessManager:	CNProcessManager
	private var mConfig:			KHConfig
	private var mResource:			KEResource

	private var mScript:			Script
	private var mExceptionCount:		Int

	public var context: KEContext { get { return mContext }}

	public init(virtualMachine vm: JSVirtualMachine, script scr: Script, processManager procmgr: CNProcessManager, queue disque: DispatchQueue, input instrm: CNFileStream, output outstrm: CNFileStream, error errstrm: CNFileStream, environment env: CNEnvironment, resource res: KEResource, config conf: KHConfig){
		mContext 		= KEContext(virtualMachine: vm)
		mChildProcessManager	= CNProcessManager()
		mConfig			= conf
		mResource		= res
		mScript			= scr
		mExceptionCount		= 0
		super.init(processManager: procmgr, queue: disque, input: instrm, output: outstrm, error: errstrm, environment: env)

		/* Add child process manager */
		procmgr.addChildManager(childManager: mChildProcessManager)

		/* Set exception handler */
		mContext.exceptionCallback = {
			[weak self]  (_ excep: KEException) -> Void in
			if let myself = self {
				myself.console.error(string: excep.description + "\n")
				myself.mExceptionCount += 1
			}
		}
	}

	public override func main(argument arg: CNNativeValue) -> Int32 {
		if compile(processManager: mChildProcessManager, config: mConfig) {
			if mConfig.hasMainFunction {
				return execOperation(argument: arg)
			} else {
				return hasNoException() ? 0 : -1
			}
		} else {
			return -1
		}
	}

	private func compile(processManager procmgr: CNProcessManager, config conf: KEConfig) -> Bool {
		/* Compile the context */
		let compiler = KHShellCompiler()
		let queue    = DispatchQueue(label: "KHScriptThreadObject", qos: .default, attributes: .concurrent)
		guard compiler.compileBaseAndLibrary(context: mContext, processManager: procmgr, queue: queue, environment: self.environment, resource: mResource, console: self.console, config: conf) else {
			console.error(string: "Failed to compile script thread context\n")
			return false
		}

		/* Make script */
		let script: String
		switch mScript {
		case .file(let url):
			if let scr = url.loadContents() {
				script = String(scr)
			} else {
				return false
			}
		case .script(let scr):
			script = scr
		case .empty:
			console.error(string: "No script")
			return false
		}
		let _ = compiler.compile(context: mContext, statement: script, console: console, config: conf)
		return hasNoException()
	}

	private func execOperation(argument arg: CNNativeValue) -> Int32 {
		/* Search main function */
		var result: Int32 = -1
		if let funcval = mContext.getValue(name: "main") {
			if !funcval.isUndefined {
				/* Allocate argument */
				let jsarg = arg.toJSValue(context: mContext)
				/* Call main function */
				if let retval = funcval.call(withArguments: [jsarg]) {
					result = retval.toInt32()
				} else {
					self.console.error(string: "Failed to call main function\n")
				}
			} else {
				self.console.error(string: "main function is NOT found\n")
			}
		} else {
			self.console.error(string: "main function is NOT found\n")
		}
		return result
	}

	open override func terminate() {
		if isRunning {
			//NSLog("Terminate script by _cancel()")
			mContext.evaluateScript("_cancel() ;")
			super.terminate()
		}
	}

	private func hasNoException() -> Bool {
		return mExceptionCount == 0
	}
}

@objc public class KHScriptThread: NSObject, KHThreadProtocol
{
	public typealias Script = KHScriptThreadObject.Script

	private var mThread:	KHScriptThreadObject

	public init(thread threadobj: KHScriptThreadObject){
		mThread = threadobj
	}

	public var isExecuting:	Bool  { get { return mThread.isRunning }}
	public var context: KEContext { get { return mThread.context   }}

	public func start(argument arg: CNNativeValue) {
		mThread.start(argument: arg)
	}

	public func start(_ args: JSValue){
		let nargs = args.toNativeValue()
		mThread.start(argument: nargs)
	}

	public func waitUntilExit() -> Int32 {
		return mThread.waitUntilExit()
	}
}


