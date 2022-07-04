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
	public override init(source src: KLSource, processManager procmgr: CNProcessManager, input ifile: CNFile, output ofile: CNFile, error efile: CNFile, terminalInfo terminfo: CNTerminalInfo, environment env: CNEnvironment, config conf: KEConfig){
		super.init(source: src, processManager: procmgr, input: ifile, output: ofile, error: efile, terminalInfo: terminfo, environment: env, config: conf)
	}

	open override func compile(context ctxt: KEContext, resource res: KEResource, processManager procmgr: CNProcessManager, terminalInfo terminfo: CNTerminalInfo, environment env: CNEnvironment, console cons: CNFileConsole, config conf: KEConfig) -> Bool {
		if super.compile(context: ctxt, resource: res, processManager: procmgr, terminalInfo: terminfo, environment: env, console: cons, config: conf) {
			/* Readline */
			let readln   = CNReadline(terminalInfo: terminfo, environment: env)
			let compiler = KHShellCompiler()
			if compiler.compile(context: ctxt, readline: readln, resource: res, processManager: procmgr, terminalInfo: terminfo, console: cons, environment: env, config: conf) {
				return true
			} else {
				console.error(string: "Failed to compile script thread context\n")
				return false
			}
		} else {
			return false
		}
	}

	open override func convert(script scr: String, pathExtension ext: String?) -> String? {
		var isshellscr = false
		if let e = ext {
			if e == "sh" || e == "jsh" {
				isshellscr = true
			}
		}
		if isshellscr {
			return convertShellScript(script: scr)
		} else {
			return scr	// needless to convert
		}
	}

	private func convertShellScript(script scr: String) -> String? {
		let lines = scr.components(separatedBy: "\n")
		let result: String?
		/* convert script */
		let parser = KHShellParser()
		switch parser.parse(lines: lines, environment: self.environment) {
		case .ok(let stmts0):
			let stmts1  = KHCompileShellStatement(statements: stmts0)
			let script2 = KHGenerateScript(from: stmts1)

			var stmts3: Array<String> = ["function main(){\n"]
			stmts3.append(contentsOf: script2)
			stmts3.append("}\n")

			result = stmts3.joined(separator: "\n")
		case .error(let err):
			let errobj  = err as NSError
			let errmsg  = errobj.toString()
			self.console.error(string: errmsg + "\n")
			result      = nil
		}
		return result
	}

	open override func terminate() {
		if super.status.isRunning {
			let srcfile = URL(fileURLWithPath: #file)
			self.context.evaluateScript("_cancel() ;", withSourceURL: srcfile)
			super.terminate()
		}
	}
}


