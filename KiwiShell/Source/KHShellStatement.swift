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

	public func toScript(processId pid: Int) -> String {
		let stmt = self.statement.trimmingCharacters(in: .whitespacesAndNewlines)
		let instr, outstr, errstr: String
		if let str = inputName  { instr  = str } else { instr  = "stdin"  }
		if let str = outputName { outstr = str } else { outstr = "stdout" }
		if let str = errorName  { errstr = str } else { errstr = "stderr" }
		let system = "let _proc\(pid) = system(`\(stmt)`, \(instr), \(outstr), \(errstr)) ;"
		return system
	}
}

public class KHShellStatements
{
	private var mStatements:	Array<KHShellStatement>
	private var mPipes:		Array<String>
	private var mIndent: 		String

	public init(statements stmts: Array<String>, indent idt: String) {
		mStatements = []
		mPipes	    = []
		mIndent     = idt
		for stmt in stmts {
			mStatements.append(KHShellStatement(statement: stmt))
		}
	}

	public func insertPipes() {
		let stmtnum = mStatements.count
		if stmtnum >= 2 {
			for i in 0..<stmtnum-1 {
				let pipe = "_pipe\(i)"
				mStatements[i  ].outputName = pipe
				mStatements[i+1].inputName  = pipe
				mPipes.append(pipe)
			}
		}
	}

	public func toScript() -> Array<String> {
		var result: Array<String> = []

		/* Set header */
		result.append(mIndent + "do {")
		/* Define pipes */
		for pipe in mPipes {
			let stmt = "let \(pipe) = Pipe() ;"
			result.append(mIndent + "\t" + stmt)
		}
		/* Set body */
		var pid: Int = 0
		for stmt in mStatements {
			result.append(mIndent + "\t" + stmt.toScript(processId: pid))
			pid += 1
		}
		/* Insert waits */
		for i in 0..<pid {
			let stmt = "_proc\(i).waitUntilExit() ;"
			result.append(mIndent + "\t" + stmt)
		}
		/* Set footer */
		result.append(mIndent + "} while(false) ;")
		return result
	}
}

