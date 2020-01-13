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
	var newstmts:		Array<KHStatement>	= []
	var hasnewstmts: 	Bool			= false
	for stmt in stmts {
		var curstmt: KHStatement = stmt

		/*
		if let readline = rdln {
			let replayconv = KHReplayCommandConverter(readline: readline)
			if let newstmt = replayconv.accept(statement: curstmt) {
				hasnewstmts = true
				curstmt     = newstmt
			}
		}*/

		let builtinconv = KHBuiltinCommandConverter()
		if let newstmt = builtinconv.accept(statement: curstmt) {
			hasnewstmts = true
			curstmt     = newstmt
		}

		newstmts.append(curstmt)
	}
	return hasnewstmts ? newstmts : stmts
}

/*
private class KHReplayCommandConverter: KHShellStatementConverter
{
	private var mReadline: CNReadline

	public init(readline rdln: CNReadline) {
		mReadline = rdln
	}

	open override func visit(shellCommandStatement stmt: KHShellCommandStatement) -> KHShellCommandStatement? {
		if let newcmd = convertToReplayCommand(command: stmt.shellCommand) {
			return KHShellCommandStatement(shellCommand: newcmd)
		} else {
			return nil
		}
	}

	private func convertToReplayCommand(command cmd: String) -> String? {
		var result: String? = nil
		if cmd.count >= 2 {
			var mcmd = cmd
			if mcmd.removeFirst() == "!" {
				if let idx = Int(mcmd) {
					result = mReadline.search(byIndex: idx)
				}
			}
		}
		return result
	}
}
*/

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



