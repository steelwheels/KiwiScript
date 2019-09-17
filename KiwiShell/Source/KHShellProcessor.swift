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
		if let intf = KHShellInterface.parse(string: stmts) {
			return try convert(shellInterface: intf)
		} else {
			/* Normal script */
			return stmts
		}
	}

	private func convert(shellInterface intf: KHShellInterface) throws -> String {
		/* get input file name */
		let inputstr: String
		if let str = intf.inputFileName {
			inputstr = str
		} else {
			inputstr = "stdin"
		}

		/* get output file name */
		let outputstr: String
		if let str = intf.outputFileName {
			outputstr = str
		} else {
			outputstr = "stdout"
		}

		/* get error file name */
		let errorstr: String
		if let str = intf.errorFileName {
			errorstr = str
		} else {
			errorstr = "stderr"
		}

		/* get command line: Escape "`" because the string will be enclosed by it */
		let cmdline: String
		if let line = intf.shellStatement {
			cmdline = escapeSymbols(shellLine: line)
		} else {
			cmdline = "echo \"Error\""
		}

		/* Get process instance name */
		let procname = uniqueProcessInstance()

		/* Make script */
		let script =   "let \(procname) = system(`\(cmdline)`, \(inputstr), \(outputstr), \(errorstr)) ;\n"
			     + "\(procname).waitUntilExit() ;\n"
		return script
	}

	private func escapeSymbols(shellLine line: String) -> String {
		/* Escape " symbol
		*   `  -> \`
		*   \` -> \\`"
		*/
		var newsublines: Array<String> = []
		let sublines = line.components(separatedBy: "\\`")
		for subline in sublines {
			let newsubline = subline.replacingOccurrences(of: "`", with: "\\`")
			newsublines.append(newsubline)
		}
		return newsublines.joined(separator: "\\\\`")
	}

	private var mUniqueProcessID: Int = 0
	private func uniqueProcessInstance() -> String {
		let procid = mUniqueProcessID
		mUniqueProcessID += 1
		return "_process\(procid)"
	}
}
