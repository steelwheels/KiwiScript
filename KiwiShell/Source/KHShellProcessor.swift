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


	public init(){

	}

	public func convert(statements stmts: Array<String>) -> Result {
		do {
			var result: Array<String> = []
			for stmt in stmts {
				let ret = try convert(statements: stmt)
				result.append(ret)
			}
			return .finished(result)
		} catch let err as CompileError {
			return .error(err)
		} catch {
			return .error(.unknownError)
		}
	}

	private func convert(statements stmts: String) throws -> String {
		if let shstmt = getShellStatement(statement: stmts) {
			return try convert(shellStatements: shstmt)
		} else {
			return stmts
		}
	}

	private func getShellStatement(statement stmt: String) -> String? {
		var idx = stmt.startIndex
		let end = stmt.endIndex
		while idx < end {
			let c = stmt[idx]
			if c == ">" {
				let fidx = stmt.index(after: idx)
				if fidx < end {
					return String(stmt[fidx..<end])
				} else {
					return nil
				}
			} else if !c.isSpace() {
				return nil
			}
			idx = stmt.index(after: idx)
		}
		return nil
	}

	private func convert(shellStatements stmts: String) throws -> String {
		/* Divide by ";" */
		let lines = stmts.components(separatedBy: ";")
		var result: Array<String> = []
		for line in lines {
			let res = try convert(shellLine: line)
			result.append(res)
		}
		/* join by ";" */
		return result.joined(separator: ";")
	}

	private func convert(shellLine line: String) throws -> String {
		return "system(\"\(line)\", stdin, stdout, stderr)"
	}
}
