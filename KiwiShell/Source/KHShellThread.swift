/**
 * @file	KHShell.swift
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
}

@objc public class KHShellThread: CNShellThread, KHShellThreadProtocol
{
	private var mContext:		KEContext

	public init(virtualMachine vm: JSVirtualMachine, shellInterface intf: CNShellInterface, environment env: CNShellEnvironment, console cons: CNConsole, config conf: KEConfig){
		mContext	= KEContext(virtualMachine: vm)
		super.init(interface: intf, environment: env, console: cons, config: conf)

		/* Compile the context */
		let compiler = KHShellCompiler()
		guard compiler.compile(context: mContext, environment: env, console: cons, config: conf) else {
			cons.error(string: "Failed to compile script thread context\n")
			return
		}
		/* Set exception handler */
		mContext.exceptionCallback = {
			[weak self]  (_ excep: KEException) -> Void in
			if let myself = self {
				let desc = excep.description
				myself.output(string: "[Exception] \(desc)\n")
			}
		}
		/* Define built-in functions */
		compiler.defineBuiltinFunctions(parentThread: self, context: mContext)
	}

	public override func promptString() -> String {
		return "jsh$ "
	}

	open override func parse(line str: String){
		if !isEmpty(line: str) {
			//super.output(string: "[\(line)]\n")
			if let retval = mContext.evaluateScript(str) {
				if !retval.isUndefined, let retstr = retval.toString() {
					super.output(string: "\(retstr)\n")
				}
			}
		}
	}

	private func isEmpty(line str: String) -> Bool {
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


