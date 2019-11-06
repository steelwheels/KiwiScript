/**
 * @file	KHShellThread.swift
 * @brief	Define KHShell class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutShell
import CoconutData
import KiwiEngine
import KiwiLibrary
import JavaScriptCore
import Foundation

@objc public protocol KHShellThreadProtocol: KHThreadProtocol
{
	func start()
}

@objc public class KHShellThread: CNShellThread, KHShellThreadProtocol
{
	private var mContext:		KEContext

	public init(virtualMachine vm: JSVirtualMachine, resource res: KEResource, input instrm: CNFileStream, output outstrm: CNFileStream, error errstrm: CNFileStream, environment env: CNShellEnvironment, config conf: KEConfig){
		mContext	= KEContext(virtualMachine: vm)
		super.init(input: instrm, output: outstrm, error: errstrm, environment: env, config: conf, terminationHander: nil)

		/* Compile the context */
		let shellconf = KEConfig(kind: .Terminal, doStrict: conf.doStrict, logLevel: conf.logLevel)
		let compiler  = KHShellCompiler()
		guard compiler.compileShell(context: mContext, environment: env, resource: res, console: console, config: shellconf) else {
			console.error(string: "Failed to compile script thread context\n")
			return
		}
		/* Set exception handler */
		mContext.exceptionCallback = {
			[weak self]  (_ excep: KEException) -> Void in
			if let myself = self {
				let desc = excep.description
				myself.console.error(string: "[Exception] \(desc)\n")
			}
		}
	}

	public override func promptString() -> String {
		return "jsh$ "
	}

	open override func execute(command cmd: String){
		if !isEmpty(string: cmd) {
			/* convert script */
			let translator = KHShellTranslator()
			switch translator.translate(lines: [cmd]) {
			case .ok(let lines):
				let script = lines.joined(separator: "\n")
				if let retval = mContext.evaluateScript(script) {
					if !retval.isUndefined, let retstr = retval.toString() {
						self.outputFileHandle.write(string: retstr)
					}
				}
			case .error(let err):
				let errobj = err as NSError
				let errmsg = errobj.toString()
				self.errorFileHandle.write(string: errmsg + "\n")
			}
		}
	}

	private func isEmpty(string str: String) -> Bool {
		var result = true
		for c in str {
			if !c.isWhitespace {
				result = false
				break
			}
		}
		return result
	}
}


