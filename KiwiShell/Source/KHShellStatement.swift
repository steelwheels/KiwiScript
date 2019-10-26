/**
 * @file	KHShellStatement.swift
 * @brief	Define KHShellStatement class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import Foundation

public struct KHShellStatement
{
	public var 	statement:	String
	public var	inputName:	String?
	public var	outputName:	String?
	public var	errorName:	String?

	public init(statement stmt: String) {
		statement	= stmt
		inputName	= nil
		outputName	= nil
		errorName	= nil
	}

	public func toScript() -> String {
		let stmt = self.statement.trimmingCharacters(in: .whitespacesAndNewlines)
		let instr, outstr, errstr: String
		if let str = inputName  { instr  = str } else { instr  = "stdin"  }
		if let str = outputName { outstr = str } else { outstr = "stdout" }
		if let str = errorName  { errstr = str } else { errstr = "stderr" }
		let system = "system(`\(stmt)`, \(instr), \(outstr), \(errstr)) ;"
		return system
	}
}

public class KHShellStatements
{
	private var mStatements:	Array<KHShellStatement>
	private var mIndent: 		String

	public init(statements stmts: Array<String>, indent idt: String) {
		mStatements = []
		mIndent     = idt
		for stmt in stmts {
			mStatements.append(KHShellStatement(statement: stmt))
		}
	}

	public func toScript() -> Array<String> {
		var result: Array<String> = []

		/* Set header */
		result.append(mIndent + "do {")
		/* Set body */
		for stmt in mStatements {
			result.append(mIndent + "\t" + stmt.toScript())
		}
		/* Set footer */
		result.append(mIndent + "} while(false) ;")
		return result
	}
}

