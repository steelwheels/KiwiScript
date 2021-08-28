/**
 * @file	KHShellParser.swift
 * @brief	Define KHShellParser class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

import KiwiLibrary
import CoconutData
import CoconutShell
import Foundation

public class KHShellParser
{
	public enum Result {
		case ok(Array<KHStatement>)
		case error(Error)
	}

	private enum TranslationMode {
		case script
		case shell
	}

	public init(){

	}

	/* lines: The array of lines which is terminated by '\n' */
	public func parse(lines lns: Array<String>, environment env: CNEnvironment) -> Result {
		do {
			let stmts = try parseMain(lines: lns, environment: env)
			return .ok(stmts)
		} catch let err {
			return .error(err)
		}
	}

	public func parseMain(lines lns: Array<String>, environment env: CNEnvironment) throws -> Array<KHStatement> {
		/* Make environment value table */
		var envdict: Dictionary<String, String> = [:]
		for name in env.variableNames {
			if let val = env.get(name: name) {
				if let str = environmentValueToString(value: val) {
					envdict["${" + name + "}"] = str
				} else {
					CNLog(logLevel: .error, message: "Failed to get environment value: \(name)", atFunction: #function, inFile: #file)
				}
			}
		}

		var result: Array<KHStatement>   = []
		var buffer: Array<String>   = []
		var mode:   TranslationMode = .script
		var indent: String          = ""
		for line in lns {
			switch mode {
			case .script:
				if isShellLine(line: line) {
					/* script -> shell */
					if buffer.count > 0 {
						let newstmt = KHScriptStatement(script: buffer)
						result.append(newstmt)
					}
					/* Replace environment variable */
					let eline = replaceEnvironmentVariable(line: line, dictionary: envdict)
					buffer = [eline]
					mode = .shell
					/* Keep indent for shell statements */
					indent = CNStringUtil.spacePrefix(string: line)
				} else {
					/* script -> script */
					buffer.append(line)
					mode = .script
				}
			case .shell:
				if isShellLine(line: line) {
					/* shell -> shell */
					/* Replace environment variable */
					let eline = replaceEnvironmentVariable(line: line, dictionary: envdict)
					buffer.append(eline)
					mode = .shell
				} else {
					/* shell -> script */
					if buffer.count > 0 {
						let newstmt = try convertToShellStatement(lines: buffer, indent: indent)
						result.append(newstmt)
					}
					buffer = [line]
					mode = .script
				}
			}
		}
		if buffer.count > 0 {
			/* Flush the buffer */
			switch mode {
			case .script:
				let newstmt = KHScriptStatement(script: buffer)
				result.append(newstmt)
			case .shell:
				let newstmt = try convertToShellStatement(lines: buffer, indent: indent)
				result.append(newstmt)
			}
		}
		return result
	}

	private func isShellLine(line ln: String) -> Bool {
		let start = ln.startIndex
		let end   = ln.endIndex
		var idx   = start
		while idx < end {
			let c = ln[idx]
			if c.isWhitespace {
				/* continue */
			} else if c == ">" {
				return true
			} else {
				break
			}
			idx = ln.index(after: idx)
		}
		return false
	}

	private func environmentValueToString(value val: CNValue) -> String? {
		var result: String? = nil
		switch val {
		case .stringValue(let str):
			result = str
		case .URLValue(let url):
			result = url.path
		case .numberValue(let num):
			result = num.description
		case .arrayValue(let arr):
			var is1st = true
			var str   = ""
			for elm in arr {
				if is1st {
					is1st = false
				} else {
					str += ":"
				}
				if let estr = environmentValueToString(value: elm) {
					str += estr
				}
			}
			result = str
		default:
			CNLog(logLevel: .error, message: "Unsupported environment value type: \(val.valueType.description)", atFunction: #function, inFile: #file)
		}
		return result
	}

	private func replaceEnvironmentVariable(line ln: String, dictionary dict: Dictionary<String, String>) -> String {
		return dict.reduce(ln){
			$0.replacingOccurrences(of: $1.key, with: $1.value)
		}
	}

	private func convertToShellStatement(lines lns: Array<String>, indent idt: String) throws -> KHMultiStatements {
		/* Allocate statemets object */
		let topstmt = KHMultiStatements()

		/* Remove ">" symbol from header */
		var lines: Array<String> = []
		for line in lns {
			lines.append(try removeHeader(line: line))
		}

		/* Connect lines before splitting and devide by pipe '|' */
		var script = lines.joined(separator: "\n")

		/* Get exit code after '->' */
		let exitcode: String?
		(script, exitcode) = decodeExitCode(script: script)

		/* Allocate shell processes */
		let pipes = script.components(separatedBy: ";")
		for pipe in pipes {
			let pipe1 = pipe.trimmingCharacters(in: .whitespacesAndNewlines)
			if !pipe1.isEmpty {
				let stmt = try convertToPipeline(statement: pipe1)
				topstmt.add(statement: stmt)
			}
		}

		/* Set exit code name to the last pipeline */
		if let ecode = exitcode, let laststmt = topstmt.pipelineStatements.last {
			laststmt.exitCode = ecode
		}

		return topstmt
	}

	private func removeHeader(line ln: String) throws -> String {
		let start = ln.startIndex
		let end   = ln.endIndex
		var idx   = start
		while idx < end {
			let c = ln[idx]
			if c.isWhitespace {
				/* continue */
				idx = ln.index(after: idx)
			} else if c == ">" {
				idx = ln.index(after: idx)
				break
			} else {
				throw NSError.parseError(message: "Internal error")
			}
		}
		return String(ln.suffix(from: idx))
	}

	private func decodeExitCode(script scr: String) -> (String, String?) { // (script, exit-code?)
		let start = scr.startIndex
		let end   = scr.endIndex
		if start < end {
			/* Skip spaces */
			let skipspaces = { (_ c: Character) -> Bool in return c.isWhitespace }
			let ptr0 = CNStringUtil.traceBackward(string: scr, pointer: end, doSkipFunc: skipspaces)
			/* Skip identifier */
			let skipidents = { (_ c: Character) -> Bool in return c.isLetterOrNumber }
			let ptr1 = CNStringUtil.traceBackward(string: scr, pointer: ptr0, doSkipFunc: skipidents)
			/* Skip spaces*/
			let ptr2 = CNStringUtil.traceBackward(string: scr, pointer: ptr1, doSkipFunc: skipspaces)
			if start < ptr2 && ptr2 < ptr0 {
				/* Check prev '>' */
				let ptr3 = scr.index(before: ptr2)
				if start < ptr3 && scr[ptr3] == ">" {
					let ptr4 = scr.index(before: ptr3)
					/* Check prev '-' */
					if scr[ptr4] == "-" {
						let lastidx = scr.index(before: ptr4)
						let prevscr = scr.prefix(upTo: lastidx)
						let aftscr  = scr.suffix(from: ptr1)
						return (String(prevscr), String(aftscr))
					}
				}
			}

		}
		return (scr, nil)
	}

	private func convertToPipeline(statement stmt: String) throws -> KHPipelineStatement {
		let pipe  = KHPipelineStatement()
		let comps = stmt.components(separatedBy: "|")
		for comp1 in comps {
			let comp2 = comp1.trimmingCharacters(in: .whitespacesAndNewlines)

			let (cmdstr1, inname)  = searchRedirect(symbol: "<",  in: comp2   )
			let (cmdstr2, errname) = searchRedirect(symbol: "2>", in: cmdstr1)
			let (cmdstr3, outname) = searchRedirect(symbol: ">",  in: cmdstr2)
			let newstmt = KHShellCommandStatement(shellCommand: cmdstr3)
			newstmt.inputName  = inname
			newstmt.outputName = outname
			newstmt.errorName  = errname
			pipe.add(statement: newstmt)
		}
		return pipe
	}

	private func searchRedirect(symbol symstr: String, in str: String) -> (String, String?) // (str, pipe-name)
	{
		if let symrange = str.range(of: symstr) {
			let head = symrange.lowerBound

			/* Search "@" symbol */
			/* Skip heading spaces */
			let start = CNStringUtil.traceForward(string: str, pointer: symrange.upperBound, doSkipFunc: {
				(_ c: Character) -> Bool in return c.isWhitespace
			})
			if start < str.endIndex {
				/* Find "@" */
				let c = str[start]
				if c == "@" {
					let beginptr = str.index(after: start)
					let endptr   = CNStringUtil.traceForward(string: str, pointer: beginptr, doSkipFunc: {
						(_ c: Character) -> Bool in return c.isLetterOrNumber
					})
					if beginptr < endptr {
						let word   = String(str[beginptr..<endptr])
						let newstr = str.replacingCharacters(in: head..<endptr, with: "")
						return (newstr, word)
					}
				}
			}
		}
		return (str, nil)
	}
}
