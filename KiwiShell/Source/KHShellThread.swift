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
	private var mProcessor:		KHShellProcessor

	public init(virtualMachine vm: JSVirtualMachine, input inhdl: FileHandle, output outhdl: FileHandle, error errhdl: FileHandle, environment env: CNShellEnvironment, config conf: KEConfig){
		mContext	= KEContext(virtualMachine: vm)
		mProcessor	= KHShellProcessor(context: mContext)
		super.init(input: inhdl, output: outhdl, error: errhdl, environment: env, config: conf, terminationHander: nil)

		/* Compile the context */
		let compiler = KHShellCompiler()
		guard compiler.compile(context: mContext, environment: env, console: console, config: conf) else {
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
		/* Define built-in functions */
		compiler.defineBuiltinFunctions(context: mContext)
	}

	public override func promptString() -> String {
		return "jsh$ "
	}

	open override func inputLine(line str: String){
		if !isEmpty(string: str) {
			/* Translate built-in function */
			let procres = mProcessor.convert(statements: [str])
			switch procres {
			case .finished(let stmts):
				/* Execute as JavaScript code */
				let script = stmts.joined(separator: "\n")
				if let retval = mContext.evaluateScript(script) {
					if !retval.isUndefined, let retstr = retval.toString() {
						self.outputFileHandle.write(string: retstr)
					}
				}
			case .error(let err):
				let desc = err.descriotion()
				self.errorFileHandle.write(string: desc + "\n")
			}
		}
	}

	private func isEmpty(string str: String) -> Bool {
		var result = true
		for c in str {
			if !c.isSpace() {
				result = false
				break
			}
		}
		return result
	}
}


