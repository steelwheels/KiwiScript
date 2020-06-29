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
	private var mContext:			KEContext?
	private var mChildProcessManager:	CNProcessManager
	private var mTerminalInfo:		CNTerminalInfo
	private var mConfig:			KHConfig
	private var mExternalCompiler:		KHExternalCompiler?

	private var mSourceFile:		KESourceFile
	private var mExceptionCount:		Int

	public init(sourceFile srcfile: KESourceFile, processManager procmgr: CNProcessManager, input instrm: CNFileStream, output outstrm: CNFileStream, error errstrm: CNFileStream, externalCompiler excomp: KHExternalCompiler?, environment env: CNEnvironment, config conf: KHConfig){
		mContext		= nil
		mChildProcessManager	= CNProcessManager()
		mTerminalInfo		= CNTerminalInfo(width: 80, height: 25)
		mConfig			= conf
		mExternalCompiler	= excomp
		mSourceFile		= srcfile
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
		if compile(sourceFile: mSourceFile, processManager: mChildProcessManager, context: ctxt, config: mConfig) {
			if mConfig.hasMainFunction {
				return execOperation(argument: arg, context: ctxt)
			} else {
				return hasNoException() ? 0 : -1
			}
		} else {
			return -1
		}
	}

	private func compile(sourceFile srcfile: KESourceFile, processManager procmgr: CNProcessManager, context ctxt: KEContext, config conf: KEConfig) -> Bool {
		/* Compile the context */
		let compiler = KHShellCompiler()
		guard compiler.compileBaseAndLibrary(context: ctxt, sourceFile: srcfile, processManager: procmgr, terminalInfo: mTerminalInfo, environment: self.environment, console: self.console, config: conf) else {
			console.error(string: "Failed to compile script thread context\n")
			return false
		}

		/* Make script */
		let script: String
		switch srcfile {
		case .none:
			console.error(string: "No script\n")
			return false
		case .file(let url):
			if let scr = url.loadContents() {
				script = String(scr)
			} else {
				return false
			}
		case .script(let scr):
			script = scr
		case .resource(let res):
			if let scr = res.loadApplication() {
				script = scr
			} else {
				return false
			}
		case .thread(let name, let res):
			if let scr = res.loadThread(identifier: name) {
				script = scr
			} else {
				return false
			}
		}
		let _ = compiler.compile(context: ctxt, statement: script, console: console, config: conf)

		/* Call external compiler */
		if let extcomp = mExternalCompiler {
			if !extcomp.compile(context: ctxt, config: conf) {
				return false
			}
		}
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

@objc public class KHScriptThread: NSObject, KHThreadProtocol
{
	private var mThread:	KHScriptThreadObject

	public init(thread threadobj: KHScriptThreadObject){
		mThread = threadobj
	}

	public var isExecuting:	Bool  { get { return mThread.isRunning }}

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


