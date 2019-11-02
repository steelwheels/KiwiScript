/**
 * @file	KHShellTranslator.swift
 * @brief	Define KHShellTranslator class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KHShellTranslator
{
	public enum Result {
		case 	ok(Array<String>)
		case	error(Error)
	}

	public init(){
	}

	/*
	 * lines:	The array of lines which is terminated by '\n'
	 */
	public func translate(lines lns: Array<String>) -> Result {
		do {
			let newlns = try mainTranslate(lines: lns)
			return .ok(newlns)
		} catch let err {
			return .error(err)
		}
	}

	private enum TranslationState {
	case normalStatement
	case shellStatement
	}

	private func mainTranslate(lines lns: Array<String>) throws -> Array<String> {
		var result: Array<String>   = []
		var buffer: Array<String>   = []
		var state: TranslationState = .normalStatement
		var indent: String          = ""
		for line in lns {
			switch state {
			case .normalStatement:
				if isShellLine(line: line) {
					/* normal -> shell */
					result.append(contentsOf: buffer)
					indent = CNStringUtil.spacePrefix(string: line)
					buffer = [line]
					state = .shellStatement
				} else {
					/* normal -> normal */
					buffer.append(line)
					state = .normalStatement
				}
			case .shellStatement:
				if isShellLine(line: line) {
					/* shell -> shell */
					buffer.append(line)
					state = .shellStatement
				} else {
					/* shell -> normal */
					let modlines = try convert(lines: buffer, indent: indent)
					result.append(contentsOf: modlines)
					buffer = [line]
					state = .normalStatement
				}
			}
		}
		if buffer.count > 0 {
			/* Flush the buffer */
			switch state {
			case .normalStatement:
				result.append(contentsOf: buffer)
			case .shellStatement:
				let modlines = try convert(lines: buffer, indent: indent)
				result.append(contentsOf: modlines)
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
			if c.isSpace() {
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

	private func removeHeader(line ln: String) throws -> String {
		let start = ln.startIndex
		let end   = ln.endIndex
		var idx   = start
		while idx < end {
			let c = ln[idx]
			if c.isSpace() {
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

	private func convert(lines lns: Array<String>, indent idt: String) throws -> Array<String> {
		/* Allocate statemets object */
		let shstmts = KHShellStatements(indent: idt)

		/* Remove ">" symbol from header */
		var lines: Array<String> = []
		for line in lns {
			lines.append(try removeHeader(line: line))
		}

		/* Connect lines before splitting and devide by pipe '|' */
		var script = lines.joined(separator: "\n")

		/* Get exit code after '->' */
		(script, shstmts.exitVariable) = decodeExitCode(script: script)

		/* Allocate shell processes */
		let procs = script.components(separatedBy: "|")
		for proc in procs {
			let proc1 = proc.trimmingCharacters(in: .whitespacesAndNewlines)
			if !proc1.isEmpty {
				let shproc = try convert(process: proc1)
				shstmts.add(process: shproc)
			}
		}

		/* Check the context */
		if let err = shstmts.check() {
			throw err
		}

		/* Compile the context */
		if let err = shstmts.compile() {
			throw err
		}

		/* Generate script */
		return shstmts.toScript()
	}

	private func decodeExitCode(script scr: String) -> (String, String?) { // (script, exit-code?)
		let start = scr.startIndex
		let end   = scr.endIndex
		if start < end {
			/* Skip spaces */
			let skipspaces = { (_ c: Character) -> Bool in return c.isSpace() }
			let ptr0 = CNStringUtil.traceBackward(string: scr, pointer: end, doSkipFunc: skipspaces)
			/* Skip identifier */
			let skipidents = { (_ c: Character) -> Bool in return c.isAlphaOrNum() }
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
						let prevscr = scr.prefix(upTo: ptr4)
						let aftscr  = scr.suffix(from: ptr1)
						return (String(prevscr), String(aftscr))
					}
				}
			}

		}
		return (scr, nil)
	}

	private func convert(process proc: String) throws -> KHShellProcess {
		let result = KHShellProcess()
		let cmds = proc.components(separatedBy: "|")
		for cmd in cmds {
			let cmd1 = cmd.trimmingCharacters(in: .whitespacesAndNewlines)
			if !cmd1.isEmpty {
				let shcmd = try convert(command: cmd1)
				result.add(command: shcmd)
			}
		}
		return result
	}

	private func convert(command cmd: String) throws -> KHShellCommand {
		return KHShellCommand(command: cmd)
	}

	private func skipPreviousSpaces(string str: String, startIndex start: String.Index, pointer ptr: String.Index) -> String.Index {
		var idx = ptr
		while idx < start {
			if str[idx].isSpace() {
				idx = str.index(before: idx)
			} else {
				break
			}
		}
		return idx
	}
}

