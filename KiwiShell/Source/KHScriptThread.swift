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

open class KHScriptThread: KLThread
{
	public override init(source src: KLSource, processManager procmgr: CNProcessManager, input instrm: CNFileStream, output outstrm: CNFileStream, error errstrm: CNFileStream, environment env: CNEnvironment, config conf: KEConfig){
		super.init(source: src, processManager: procmgr, input: instrm, output: outstrm, error: errstrm, environment: env, config: conf)
	}

	open override func compile(context ctxt: KEContext, resource res: KEResource, processManager procmgr: CNProcessManager, terminalInfo terminfo: CNTerminalInfo, environment env: CNEnvironment, console cons: CNFileConsole, config conf: KEConfig) -> Bool {
		if super.compile(context: ctxt, resource: res, processManager: procmgr, terminalInfo: terminfo, environment: env, console: cons, config: conf) {
			let compiler = KHShellCompiler()
			if compiler.compile(context: ctxt, resource: res, processManager: procmgr, terminalInfo: terminfo, console: cons, environment: env, config: conf) {
				return true
			} else {
				console.error(string: "Failed to compile script thread context\n")
				return false
			}
		} else {
			return false
		}
	}

	open override func terminate() {
		if isRunning {
			//NSLog("Terminate script by _cancel()")
			self.context.evaluateScript("_cancel() ;")
			super.terminate()
		}
	}
}


