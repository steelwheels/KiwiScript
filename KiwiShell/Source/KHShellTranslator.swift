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
		case ok(Array<String>)
		case error(Error)
	}

	private enum TranslationState {
		case normalStatement
		case shellStatement
	}

	public init(){
	}

	/* lines: The array of lines which is terminated by '\n' */
	public func translate(lines lns: Array<String>) -> Result {
		do {
			let newlns = try mainTranslate(lines: lns)
			return .ok(newlns)
		} catch let err {
			return .error(err)
		}
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

	private func convert(lines lns: Array<String>, indent idt: String) throws -> Array<String> {
		/* Allocate statemets object */
		let pipeline = KHPipelineStatement()

		/* Remove ">" symbol from header */
		var lines: Array<String> = []
		for line in lns {
			lines.append(try removeHeader(line: line))
		}

		/* Connect lines before splitting and devide by pipe '|' */
		var script = lines.joined(separator: "\n")

		/* Get exit code after '->' */
		(script, pipeline.exitName) = decodeExitCode(script: script)

		/* Allocate shell processes */
		let procs = script.components(separatedBy: "|")
		for proc in procs {
			let proc1 = proc.trimmingCharacters(in: .whitespacesAndNewlines)
			if !proc1.isEmpty {
				let shproc = try convert(process: proc1)
				pipeline.add(process: shproc)
			}
		}

		/* Generate script with indent string */
		var newstmts: Array<String> = []
		newstmts.append(idt + "do {")
		let stmts = pipeline.toScript()
		for stmt in stmts {
			newstmts.append(idt + "\t" + stmt)
		}
		newstmts.append(idt + "} while(false) ;")
		return newstmts
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
						let prevscr = scr.prefix(upTo: ptr4)
						let aftscr  = scr.suffix(from: ptr1)
						return (String(prevscr), String(aftscr))
					}
				}
			}

		}
		return (scr, nil)
	}

	private func convert(process procstr: String) throws -> KHProcessStatement {
		let proc = KHProcessStatement()

		let cmds = procstr.components(separatedBy: ";")
		/* Check there are built in command or not */
		var hasbuiltin = false
		for cmd in cmds {
			if isBuiltinCommand(command: cmd) {
				hasbuiltin = true
				break
			}
		}
		if hasbuiltin {
			for cmd in cmds {
				if let bcmd = convertToBuiltinCommand(command: cmd) {
					proc.add(command: bcmd)
				} else {
					/* Allocate shell command */
					let cmdobj = convertShellCommand(command: cmd)
					proc.add(command: cmdobj)
				}
			}
		} else {
			/* Allocate shell command */
			let cmdobj = convertShellCommand(command: procstr)
			proc.add(command: cmdobj)
		}
		return proc
	}

	private func convertShellCommand(command cmdstr: String) -> KHShellCommandStatement {
		let (cmdstr1, inname)  = searchRedirect(symbol: "<",  in: cmdstr)
		let (cmdstr2, errname) = searchRedirect(symbol: "2>", in: cmdstr1)
		let (cmdstr3, outname) = searchRedirect(symbol: ">",  in: cmdstr2)
		let newcmd = KHShellCommandStatement(shellCommand: cmdstr3)
		newcmd.inputName  = inname
		newcmd.outputName = outname
		newcmd.errorName  = errname
		return newcmd
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

	private func isBuiltinCommand(command cmd: String) -> Bool {
		var result = false
		let words  = CNStringUtil.divideBySpaces(string: cmd)
		if words.count > 0 {
			switch words[0] {
			case "run":
				result = true
			default:
				break
			}
		}
		return result
	}

	private func convertToBuiltinCommand(command cmd: String) -> KHCommandStatement? {
		var result: KHCommandStatement? = nil
		var words = CNStringUtil.divideBySpaces(string: cmd)
		if words.count >= 1 {
			let cmdname = words.removeFirst()
			switch cmdname {
			case "run":
				result = convertToRunCommand(parameters: words)
			default:
				break
			}
		}
		return result
	}

	private func convertToRunCommand(parameters params: Array<String>) -> KHCommandStatement? {
		if params.count >= 1 {
			return KHRunCommandStatement(scriptPath: params[0])
		} else {
			return KHRunCommandStatement(scriptPath: nil)
		}
	}
}



