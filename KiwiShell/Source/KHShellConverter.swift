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

public func KHCompileShellStatement(statements stmts: Array<KHStatement>) -> Array<KHStatement>
{
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
		if let newcmd = convertToNativeBuiltinCommand(statement: stmt) {
			return newcmd
		} else if let (url, args) = convertToBuiltinScriptCommand(command: stmt.shellCommand) {
			let newstmt = KHBuiltinCommandStatement(scriptURL: url, arguments: args)
			newstmt.importProperties(source: stmt)
			return newstmt
		} else {
			return nil
		}
	}

	private func convertToNativeBuiltinCommand(statement stmt: KHShellCommandStatement) -> KHSingleStatement? {
		let (cmdnamep, restp) = CNStringUtil.cutFirstWord(string: stmt.shellCommand)
		if let cmdname = cmdnamep {
			switch cmdname {
			case "cd":
				var path: String? = nil
				if let rest = restp {
					(path, _) = CNStringUtil.cutFirstWord(string: rest)
				}
				let newstmt = KHCdCommandStatement(path: path)
				newstmt.importProperties(source: stmt)
				return newstmt
			case "run":
				var path: String? = nil
				var arg:  String? = nil
				if let rest = restp {
					(path, arg) = CNStringUtil.cutFirstWord(string: rest)
				}
				let newstmt = KHRunCommandStatement(scriptPath: path, argument: arg)
				newstmt.importProperties(source: stmt)
				return newstmt
			case "install":
				var path: String? = nil
				var arg:  String? = nil
				if let rest = restp {
					(path, arg) = CNStringUtil.cutFirstWord(string: rest)
				}
				let newstmt = KHInstallCommandStatement(scriptPath: path, argument: arg)
				newstmt.importProperties(source: stmt)
				return newstmt
			default:
				break
			}
		}
		return nil
	}

	private func convertToBuiltinScriptCommand(command cmd: String) -> (URL, Array<String>)? {
		var words = CNStringUtil.divideBySpaces(string: cmd)
		if words.count > 0 {
			if let url = KLBuiltinScripts.shared.search(scriptName: words[0]) {
				words.removeFirst()
				return (url, words)
			}
		}
		return nil
	}
}



