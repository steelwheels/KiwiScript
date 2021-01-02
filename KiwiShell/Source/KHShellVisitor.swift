/**
 * @file	KHShellVisitor.swift
 * @brief	Define KHShellVisitor class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

import Foundation

open class KHShellStatementVisitor
{
	public func accept(statement stmt: KHStatement) -> KHStatement? {
		let result: KHStatement?
		if let nstmt = stmt as? KHScriptStatement {
			result = visit(scriptStatement: nstmt)
		} else if let nstmt = stmt as? KHShellCommandStatement {
			result = visit(shellCommandStatement: nstmt)
		} else if let nstmt = stmt as? KHCdCommandStatement {
			result = visit(cdCommandStatement: nstmt)
		} else if let nstmt = stmt as? KHRunCommandStatement {
			result = visit(runCommandStatement: nstmt)
		} else if let nstmt = stmt as? KHSetupCommandStatement {
			result = visit(setupCommandStatement: nstmt)
		} else if let nstmt = stmt as? KHBuiltinCommandStatement {
			result = visit(builtinCommandStatement: nstmt)
		} else if let nstmt = stmt as? KHPipelineStatement {
			result = visit(pipelineStatement: nstmt)
		} else if let nstmt = stmt as? KHMultiStatements {
			result = visit(multiStatements: nstmt)
		} else {
			NSLog("Unknown statement")
			result = KHShellCommandStatement(shellCommand: "[Error]")
		}
		return result
	}

	open func visit(scriptStatement stmt: KHScriptStatement) -> KHSingleStatement? { return nil }
	open func visit(shellCommandStatement stmt: KHShellCommandStatement) -> KHSingleStatement? { return nil }
	open func visit(cdCommandStatement stmt: KHCdCommandStatement) -> KHSingleStatement? { return nil }
	open func visit(runCommandStatement stmt: KHRunCommandStatement) -> KHSingleStatement? { return nil }
	open func visit(setupCommandStatement stmt: KHSetupCommandStatement) -> KHSingleStatement? { return nil }
	open func visit(builtinCommandStatement stmt: KHBuiltinCommandStatement) -> KHSingleStatement? { return nil }
	open func visit(pipelineStatement stmt: KHPipelineStatement) -> KHPipelineStatement? { return nil }
	open func visit(multiStatements stmts: KHMultiStatements) -> KHMultiStatements? { return nil }
}

open class KHShellStatementConverter: KHShellStatementVisitor
{
	open override func visit(scriptStatement stmt: KHScriptStatement) -> KHSingleStatement? {
		return nil
	}

	open override func visit(shellCommandStatement stmt: KHShellCommandStatement) -> KHSingleStatement? {
		return nil
	}

	open override func visit(cdCommandStatement stmt: KHCdCommandStatement) -> KHSingleStatement? {
		return nil
	}

	open override func visit(runCommandStatement stmt: KHRunCommandStatement) -> KHSingleStatement? {
		return nil
	}

	open override func visit(setupCommandStatement stmt: KHSetupCommandStatement) -> KHSingleStatement? {
		return nil
	}

	open override func visit(builtinCommandStatement stmt: KHBuiltinCommandStatement) -> KHSingleStatement? {
		return nil
	}

	open override func visit(pipelineStatement stmt: KHPipelineStatement) -> KHPipelineStatement? {
		let newstmt = KHPipelineStatement()
		stmt.copyProperties(toPipelineStatement: newstmt)

		var didmodified = false
		let children    = stmt.singleStatements
		for child in children {
			if let newchild = self.accept(statement: child) as? KHSingleStatement {
				newstmt.add(statement: newchild)
				didmodified = true
			} else {
				newstmt.add(statement: child)
			}
		}
		return didmodified ? newstmt : nil
	}

	open override func visit(multiStatements stmts: KHMultiStatements) -> KHMultiStatements? {
		let newstmts = KHMultiStatements()
		stmts.copyProperties(toStatement: newstmts)
		var didmodified = false
		let children    = stmts.pipelineStatements
		for child in children {
			if let newchild = self.accept(statement: child) as? KHPipelineStatement {
				newstmts.add(statement: newchild)
				didmodified = true
			} else {
				newstmts.add(statement: child)
			}
		}
		return didmodified ? newstmts : nil
	}
}

