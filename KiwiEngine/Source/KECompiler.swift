/**
 * @file	KECompiler.swift
 * @brief	Define KECompiler class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import CoconutData
import JavaScriptCore
import Foundation

open class KECompiler
{
	public init(){

	}

	public func compileBase(context ctxt: KEContext, terminalInfo terminfo: CNTerminalInfo, environment env: CNEnvironment, console cons: CNFileConsole, config conf: KEConfig) -> Bool {
		/* Set strict */
		setStrictMode(context: ctxt, console: cons, config: conf)
		/* Define Enum Types */
		compileEnumTables(context: ctxt, console: cons, config: conf)
		return true
	}

	private func setStrictMode(context ctxt: KEContext, console cons: CNConsole, config conf: KEConfig){
		if conf.doStrict {
			let srcfile = URL(fileURLWithPath: #file)
			let _ = compileStatement(context: ctxt, statement: "'use strict' ;\n", sourceFile: srcfile, console: cons, config: conf)
		}
	}

	private func compileEnumTables(context ctxt: KEContext, console cons: CNConsole, config conf: KEConfig) {
		for etable in CNEnumTable.allEnumTables() {
			let scr     = etable.toScript().toStrings().joined(separator: "\n")
			let srcfile = URL(fileURLWithPath: #file)
			let _ = compileStatement(context: ctxt, statement: scr, sourceFile: srcfile, console: cons, config: conf)
		}
	}

	public func compileStatement(context ctxt: KEContext, statement stmt: String, sourceFile srcfile: URL?, console cons: CNConsole, config conf: KEConfig) -> JSValue? {
		switch conf.logLevel {
		case .nolog, .error, .warning, .debug:
			break
		case .detail:
			cons.print(string: stmt)
		@unknown default:
			break
		}
		return ctxt.evaluateScript(script: stmt, sourceFile: srcfile)
	}

	public func compileStatements(context ctxt: KEContext, statements stmts: Array<String>, sourceFile srcfile: URL?, console cons: CNConsole, config conf: KEConfig) -> JSValue? {
		let script = stmts.joined(separator: "\n")
		switch conf.logLevel {
		case .nolog, .error, .warning, .debug:
			break
		case .detail:
			cons.print(string: script)
		@unknown default:
			break
		}
		return ctxt.evaluateScript(script: script, sourceFile: srcfile)
	}

	private func compileEnumType(context ctxt: KEContext, enumType etype: CNEnumType, console cons: CNConsole, config conf: KEConfig){
		/* Compile */
		let typename = etype.typeName
		switch conf.logLevel {
		case .nolog, .error, .warning, .debug:
			break
		case .detail:
			cons.print(string: "/* Define Enum: \(typename) */\n")
		@unknown default:
			break
		}

		var enumstmt = "let \(typename) = {\n"
		var is1st = true
		for name in etype.names {
			if let value = etype.value(forMember: name) {
				if !is1st {
					enumstmt += ",\n"
				}
				is1st = false
				enumstmt += "\t\(name) : \(value.toScript())"
			} else {
				CNLog(logLevel: .error, message: "Can not happen", atFunction: #function, inFile: #file)
			}
		}
		enumstmt += "\n};\n"
		let srcfile = URL(fileURLWithPath: #file)
		let _ = compileStatement(context: ctxt, statement: enumstmt, sourceFile: srcfile, console: cons, config: conf)
	}

	public func compileDictionaryVariable(context ctxt: KEContext, destination dst: String, dictionary dict: Dictionary<String, String>, console cons: CNConsole, config conf: KEConfig){
		var stmt  = "\(dst) = {\n"
		var is1st = true
		for (key, value) in dict {
			if is1st {
				is1st = false
			} else {
				stmt = ",\n"
			}
			stmt += "\t\(key): \(value)"
		}
		stmt += "\n};\n"
		let srcfile = URL(fileURLWithPath: #file)
		let _ = compileStatement(context: ctxt, statement: stmt, sourceFile: srcfile, console: cons, config: conf)
	}

	private func message(fromError err: NSError?) -> String {
		if let e = err {
			return e.toString()
		} else {
			return "Unknown error"
		}
	}
}

