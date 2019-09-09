/**
 * @file	KHShellProcessor.swift
 * @brief	Define KHShellProcessor class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import KiwiEngine
import JavaScriptCore
import Foundation

public class KHShellProcessor
{
	private var mContext:	KEContext

	public init(context ctxt: KEContext){
		mContext = ctxt
	}

	public enum CompileError: Error {
		case noError
		case unknownError

		public func descriotion() -> String {
			let result: String
			switch self {
			case .noError:		result = ""
			case .unknownError:	result = "Unknown error"
			}
			return result
		}
	}

	public enum Result {
		case finished(_ stmts: Array<String>)
		case error(_ code: CompileError)
	}

	public func convert(statements stmts: Array<String>) -> Result {
		do {
			var result: Array<String> = []
			for stmt in stmts {
				let ret = try convert(statement: stmt)
				result.append(ret)
			}
			return .finished(result)
		} catch let err as CompileError {
			return .error(err)
		} catch {
			return .error(.unknownError)
		}
	}

	private func convert(statement stmt: String) throws -> String {
		if isShellStatement(statement: stmt) {
			return try convert(shellStatement: stmt)
		} else {
			return stmt
		}
	}

	private func isShellStatement(statement stmt: String) -> Bool {
		var idx = stmt.startIndex
		let end = stmt.endIndex
		while idx < end {
			let c = stmt[idx]
			if c == ">" {
				return true
			} else if !c.isSpace() {
				return false
			}
			idx = stmt.index(after: idx)
		}
		return false
	}

	private func convert(shellStatement stmt: String) throws -> String {
		/* Divide by ";" */
		let lines = stmt.components(separatedBy: ";")
		var result: Array<String> = []
		for line in lines {
			let res = try convert(shellLine: line)
			result.append(res)
		}
		/* join by ";" */
		return result.joined(separator: ";")
	}

	private func convert(shellLine line: String) throws -> String {
		return line
	}
}

/*
private func translate(string str: String) -> String {

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

*/
