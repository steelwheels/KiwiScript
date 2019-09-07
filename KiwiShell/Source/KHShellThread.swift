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

	public init(virtualMachine vm: JSVirtualMachine, input inhdl: FileHandle, output outhdl: FileHandle, error errhdl: FileHandle, environment env: CNShellEnvironment, config conf: KEConfig){
		mContext	= KEContext(virtualMachine: vm)
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
		compiler.defineBuiltinFunctions(input: inhdl, output: outhdl, error: errhdl, context: mContext)
	}

	public override func promptString() -> String {
		return "jsh$ "
	}

	open override func inputLine(line str: String){
		if !isEmpty(string: str) {
			/* Translate built-in function */
			let tstr = translate(string: str)
			self.outputFileHandle.write(string: "*\(tstr)*\n")
			/* Execute as JavaScript code */
			if let retval = mContext.evaluateScript(tstr) {
				if !retval.isUndefined, let retstr = retval.toString() {
					self.outputFileHandle.write(string: retstr)
				}
			}
		}
	}

	private func translate(string str: String) -> String {
		/* Divide by ";" */
		let lines = str.components(separatedBy: ";")
		var newlines: Array<String> = []
		for line in lines {
			if let newline = translate(line: line) {
				newlines.append(newline)
			} else {
				newlines.append(line)
			}
		}
		return newlines.joined(separator: ";")
	}

	private func translate(line str: String) -> String? {
		let (err, tokens) = CNStringToToken(string: str)
		switch err {
		case .NoError:
			if tokens.count > 0 {
				switch tokens[0].type {
				case .IdentifierToken(let cmdname):
					if let info = CNUnixCommandTable.shared.search(byName: cmdname) {
						let path = info.path + "/" + cmdname
						return "system(\"\(path)\")"
					}
				default:
					break
				}
			}
		default:
			break
		}
		return nil
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


