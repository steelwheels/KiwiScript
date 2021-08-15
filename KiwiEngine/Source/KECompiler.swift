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
	
	open func compileBase(context ctxt: KEContext, terminalInfo terminfo: CNTerminalInfo, environment env: CNEnvironment, console cons: CNFileConsole, config conf: KEConfig) -> Bool {
		/* Set strict */
		setStrictMode(context: ctxt, console: cons, config: conf)
		/* Define Enum Types */
		defineEnumTypes(context: ctxt, console: cons, config: conf)
		/* Set exception */
		ctxt.exceptionCallback = {
			(_ exception: KEException) -> Void in
			cons.error(string: "[Exception] \(exception.description)\n")
		}
		return true
	}

	private func setStrictMode(context ctxt: KEContext, console cons: CNConsole, config conf: KEConfig){
		if conf.doStrict {
			let _ = compile(context: ctxt, statement: "'use strict' ;\n", console: cons, config: conf)
		}
	}

	private func defineEnumTypes(context ctxt: KEContext, console cons: CNConsole, config conf: KEConfig){
		let etable = KEEnumTable.shared
		for typename in etable.typeNames.sorted() {
			if let etype = etable.search(by: typename) {
				compile(context: ctxt, enumType: etype, console: cons, config: conf)
			}
		}
	}

	public func compile(context ctxt: KEContext, statement stmt: String, console cons: CNConsole, config conf: KEConfig) -> JSValue? {
		switch conf.logLevel {
		case .nolog, .error, .warning, .debug:
			break
		case .detail:
			cons.print(string: stmt)
		@unknown default:
			break
		}
		return ctxt.evaluateScript(stmt)
	}

	public func compile(context ctxt: KEContext, statements stmts: Array<String>, console cons: CNConsole, config conf: KEConfig) -> JSValue? {
		let script = stmts.joined(separator: "\n")
		switch conf.logLevel {
		case .nolog, .error, .warning, .debug:
			break
		case .detail:
			cons.print(string: script)
		@unknown default:
			break
		}
		return ctxt.evaluateScript(script)
	}

	public func compile(context ctxt: KEContext, enumType etype: KEEnumType, console cons: CNConsole, config conf: KEConfig){
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
		for member in etype.members {
			if !is1st {
				enumstmt += ",\n"
			}
			is1st = false
			enumstmt += "\t\(member.name) : \(member.value)"
		}
		enumstmt += "\n};\n"

		let _ = compile(context: ctxt, statement: enumstmt, console: cons, config: conf)
	}

	public func compile(context ctxt: KEContext, destination dst: String, dictionary dict: Dictionary<String, String>, console cons: CNConsole, config conf: KEConfig){
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
		let _ = compile(context: ctxt, statement: stmt, console: cons, config: conf)
	}
	
	private func message(fromError err: NSError?) -> String {
		if let e = err {
			return e.toString()
		} else {
			return "Unknown error"
		}
	}
}

