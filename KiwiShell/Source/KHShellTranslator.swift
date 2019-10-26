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
		/* Remove ">" symbol from header */
		var lines0: Array<String> = []
		for line in lns {
			lines0.append(try removeHeader(line: line))
		}

		/* Connect lines before splitting and devide by pipe '|' */
		let script1 = lines0.joined(separator: "\n")
		let stmts1  = script1.components(separatedBy: "|")

		let shstmts = KHShellStatements(statements: stmts1, indent: idt)
		return shstmts.toScript()
	}
}

