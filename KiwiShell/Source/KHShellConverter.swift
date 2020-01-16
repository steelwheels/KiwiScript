/**
 * @file	KHShellConverter.swift
 * @brief	Define KHShellConverter class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

import KiwiLibrary
import CoconutShell
import CoconutData
import Foundation

public func KHCompileShellStatement(statements stmts: Array<KHStatement>, readline rdln: CNReadline?) -> Array<KHStatement>
{
	/* Setup built-in script location */
	let manager = KLBuiltinScripts.shared
	manager.setup(subdirectory: "Binary", forClass: KHShellThreadObject.self)

	var newstmts:		Array<KHStatement>	= []
	var hasnewstmts: 	Bool			= false
	for stmt in stmts {
		var curstmt: KHStatement = stmt

		let builtinconv = KHBuiltinCommandConverter()
		if let newstmt = builtinconv.accept(statement: curstmt) {
			hasnewstmts = true
			curstmt     = newstmt
		}

		newstmts.append(curstmt)
	}
	return hasnewstmts ? newstmts : stmts
}

private class KHBuiltinCommandConverter: KHShellStatementConverter
{
	open override func visit(shellCommandStatement stmt: KHShellCommandStatement) -> KHSingleStatement? {
		if let newcmd = convertToNativeBuiltinCommand(command: stmt.shellCommand) {
			return newcmd
		} else if let url = convertToBuiltinScriptCommand(command: stmt.shellCommand) {
			return KHBuiltinCommandStatement(scriptURL: url)
		} else {
			return nil
		}
	}

	private func convertToNativeBuiltinCommand(command cmd: String) -> KHSingleStatement? {
		var result: KHSingleStatement? = nil
		var words = CNStringUtil.divideBySpaces(string: cmd)
		if words.count > 0 {
			let cmdname = words.removeFirst()
			switch cmdname {
			case "run":
				result = KHRunCommandStatement(scriptPath: words.count > 0 ? words[0] : nil)
			default:
				break
			}
		}
		return result
	}

	private func convertToBuiltinScriptCommand(command cmd: String) -> URL? {
		return KLBuiltinScripts.shared.search(scriptName: cmd)
	}
}



