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

public class KHScriptThread: CNThread
{
	private var mContext:			KEContext?
	private var mThreadName:		String?
	private var mResource:			KEResource
	private var mChildProcessManager:	CNProcessManager
	private var mTerminalInfo:		CNTerminalInfo
	private var mConfig:			KHConfig
	private var mExceptionCount:		Int

	public init(threadName thname: String?, resource res: KEResource, processManager procmgr: CNProcessManager, input instrm: CNFileStream, output outstrm: CNFileStream, error errstrm: CNFileStream, environment env: CNEnvironment, config conf: KHConfig){
		mContext		= nil
		mThreadName		= thname
		mResource		= res
		mChildProcessManager	= CNProcessManager()
		mTerminalInfo		= CNTerminalInfo(width: 80, height: 25)
		mConfig			= conf
		mExceptionCount		= 0
		super.init(processManager: procmgr, input: instrm, output: outstrm, error: errstrm, environment: env)

		/* Add child process manager */
		procmgr.addChildManager(childManager: mChildProcessManager)
	}

	public override func main(argument arg: CNNativeValue) -> Int32 {
		guard let vm = JSVirtualMachine() else {
			self.console.error(string: "Failed to allocate VM\n")
			return -1
		}
		let ctxt = KEContext(virtualMachine: vm)
		mContext = ctxt

		/* Set exception handler */
		ctxt.exceptionCallback = {
			[weak self]  (_ excep: KEException) -> Void in
			if let myself = self {
				myself.console.error(string: excep.description + "\n")
				myself.mExceptionCount += 1
			}
		}

		/* Compile the script */
		if compile(threadName: mThreadName, resource: mResource, processManager: mChildProcessManager, context: ctxt, config: mConfig) {
			if mConfig.hasMainFunction {
				return execOperation(argument: arg, context: ctxt)
			} else {
				return hasNoException() ? 0 : -1
			}
		} else {
			return -1
		}
	}

	private func compile(threadName thname: String?, resource res: KEResource, processManager procmgr: CNProcessManager, context ctxt: KEContext, config conf: KEConfig) -> Bool {
		/* Compile the context */
		let compiler = KHShellCompiler()
		guard compiler.compileBaseAndLibrary(context: ctxt, resource: res, processManager: procmgr, terminalInfo: mTerminalInfo, environment: self.environment, console: self.console, config: conf) else {
			console.error(string: "Failed to compile script thread context\n")
			return false
		}

		/* Make script */
		let script: String
		if let name = thname {
			if let scr = mResource.loadThread(identifier: name) {
				script = scr
			} else {
				CNLog(logLevel: .error, message: "Failed to load thread: \(name)")
				return false
			}
		} else {
			if let scr = mResource.loadApplication() {
				script = scr
			} else {
				CNLog(logLevel: .error, message: "Failed to load application script")
				return false
			}
		}
		let _ = compiler.compile(context: ctxt, statement: script, console: console, config: conf)
		return hasNoException()
	}

	private func execOperation(argument arg: CNNativeValue, context ctxt: KEContext) -> Int32 {
		/* Search main function */
		var result: Int32 = -1
		if let funcval = ctxt.getValue(name: "main") {
			if !funcval.isUndefined {
				/* Allocate argument */
				let jsarg = arg.toJSValue(context: ctxt)
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
		guard let ctxt = mContext else {
			console.error(string: "No context\n")
			return
		}
		if isRunning {
			//NSLog("Terminate script by _cancel()")
			ctxt.evaluateScript("_cancel() ;")
			super.terminate()
		}
	}

	private func hasNoException() -> Bool {
		return mExceptionCount == 0
	}
}


