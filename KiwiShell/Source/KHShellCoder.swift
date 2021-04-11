/**
 * @file	KHShellCoder.swift
 * @brief	Define KHShellCoder class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

import KiwiLibrary
import CoconutShell
import CoconutData
import Foundation

public func KHGenerateScript(from stmts: Array<KHStatement>) -> Array<String>
{
	/* Assign process id */
	let pidconv = KHProcessIdConverter(processId: 1) // 1 == Initial process id
	for stmt in stmts {
		let _ = pidconv.accept(statement: stmt)
	}
	
	let scrconv = KHCodeConverter()
	for stmt in stmts {
		let _ = scrconv.accept(statement: stmt)
	}
	return scrconv.newStatements
}

private class KHProcessIdConverter: KHShellStatementVisitor
{
	public var processId: Int

	public init(processId pid: Int) {
		processId = pid
	}

	open override func visit(scriptStatement stmt: KHScriptStatement) -> KHScriptStatement? {
		stmt.processId = processId
		processId += 1
		return nil
	}

	open override func visit(shellCommandStatement stmt: KHShellCommandStatement) -> KHSingleStatement? {
		stmt.processId = processId
		processId += 1
		return nil
	}

	open override func visit(cdCommandStatement stmt: KHCdCommandStatement) -> KHSingleStatement? {
		stmt.processId = processId
		processId += 1
		return nil
	}

	open override func visit(historyCommandStatement stmt: KHHistoryCommandStatement) -> KHSingleStatement? {
		stmt.processId = processId
		processId += 1
		return nil
	}

	open override func visit(runCommandStatement stmt: KHRunCommandStatement) -> KHSingleStatement? {
		stmt.processId = processId
		processId += 1
		return nil
	}

	open override func visit(installCommandStatement stmt: KHInstallCommandStatement) -> KHSingleStatement? {
		stmt.processId = processId
		processId += 1
		return nil
	}

	open override func visit(builtinCommandStatement stmt: KHBuiltinCommandStatement) -> KHSingleStatement? {
		stmt.processId = processId
		processId += 1
		return nil
	}

	open override func visit(pipelineStatement stmt: KHPipelineStatement) -> KHPipelineStatement? {
		/* Child statements has smaller id */
		let children = stmt.singleStatements
		for child in children {
			let _ = accept(statement: child)
		}
		stmt.processId = processId
		processId += 1
		return nil
	}

	open override func visit(multiStatements stmt: KHMultiStatements) -> KHMultiStatements? {
		/* Child statements has smaller id */
		let children = stmt.pipelineStatements
		for child in children {
			let _ = accept(statement: child)
		}
		stmt.processId = processId
		processId += 1
		return nil
	}
}

private class KHCodeConverter: KHShellStatementVisitor
{
	public var newStatements:	Array<String>
	private var level:		Int
	private var indent:		String

	public override init(){
		newStatements	= []
		level		= 0
		indent		= ""
	}

	public func processName(_ stmt: KHStatement) -> String {
		return "_proc\(stmt.processId)"
	}

	public func pipeName(_ stmt: KHStatement) -> String {
		return "_pipe\(stmt.processId)"
	}

	public func exitCode(_ stmt: KHStatement) -> String {
		return "_ecode\(stmt.processId)"
	}

	public func incIndent(){
		level += 1
		indent = String(repeating: "\t", count: level)
	}

	public func decIndent(){
		if level > 0 {
			level -= 1
			indent = String(repeating: "\t", count: level)
		}
	}

	public func add(statement stmt: String) {
		newStatements.append(indent + stmt)
	}

	public func add(statements stmts: Array<String>) {
		for stmt in stmts {
			add(statement: stmt)
		}
	}

	open override func visit(scriptStatement stmt: KHScriptStatement) -> KHSingleStatement? {
		newStatements.append(contentsOf: stmt.script)
		return nil
	}

	open override func visit(shellCommandStatement stmt: KHShellCommandStatement) -> KHSingleStatement? {
		let procname = processName(stmt)
		let line     = "let \(procname) = system(`\(stmt.shellCommand)`, \(stmt.inputNameString), \(stmt.outputNameString), \(stmt.errorNameString)) ;"
		add(statement: line)
		return nil
	}

	open override func visit(cdCommandStatement stmt: KHCdCommandStatement) -> KHSingleStatement? {
		let path: String
		if let p = stmt.path {
			path = "\"\(p)\""
		} else {
			path = "null"
		}
		let proc  = processName(stmt)
		let stmt0 = "let \(proc) = cdcmd() ;"
		let stmt1 = "\(proc).start(\(path)) ;"
		add(statements: [stmt0, stmt1])
		return nil
	}

	open override func visit(historyCommandStatement stmt: KHHistoryCommandStatement) -> KHSingleStatement? {
		let path: String
		if let p = stmt.path {
			path = "\"\(p)\""
		} else {
			path = "null"
		}
		let proc  = processName(stmt)
		let stmt0 = "let \(proc) = \(KHHistoryCommandStatement.commandName)() ;"
		let stmt1 = "\(proc).start(\(path)) ;"
		add(statements: [stmt0, stmt1])
		return nil
	}

	open override func visit(runCommandStatement stmt: KHRunCommandStatement) -> KHSingleStatement? {
		let path: String
		if let p = stmt.scriptPath {
			path = "\"\(p)\""
		} else {
			path = "null"
		}
		var arg: String = "null"
		if let a = stmt.argument {
			if !a.isEmpty {
				arg = a
			}
		}
		let proc  = processName(stmt)
		let stmt0 = "let \(proc) = run(\(path), \(stmt.inputNameString), \(stmt.outputNameString), \(stmt.errorNameString)) ;"
		let stmt1 = "\(proc).start(\(arg)) ;"
		add(statements: [stmt0, stmt1])
		return nil
	}

	open override func visit(installCommandStatement stmt: KHInstallCommandStatement) -> KHSingleStatement? {
		let proc  = processName(stmt)
		let stmt0 = "let \(proc) = \(KLInstallCommand.builtinFunctionName)() ;"
		let stmt1 = "\(proc).start() ;"
		add(statements: [stmt0, stmt1])
		return nil
	}

	open override func visit(builtinCommandStatement stmt: KHBuiltinCommandStatement) -> KHSingleStatement? {
		let proc  = processName(stmt)
		let path  = stmt.scriptURL.path
		let stmt0 = "let \(proc) = run(\"\(path)\", \(stmt.inputNameString), \(stmt.outputNameString), \(stmt.errorNameString)) ;"

		var args: Array<String> = []
		for arg in stmt.arguments {
			args.append("\"" + arg + "\"")
		}
		let line = args.joined(separator: ", ")

		let stmt1 = "\(proc).start([\(line)]) ;"
		add(statements: [stmt0, stmt1])
		return nil
	}

	open override func visit(pipelineStatement stmt: KHPipelineStatement) -> KHPipelineStatement? {
		let stmts = stmt.singleStatements
		switch stmts.count {
		case 0:
			break
		case 1:
			visitSinglePipeline(statement: stmts[0], pipelineStatement: stmt)
		default:
			visitMultiPipeline(statements: stmts, pipelineStatement: stmt)
		}
		if let estr = stmt.exitCode {
			let ecode = exitCode(stmt)
			add(statement: "\(estr) = \(ecode) ;")
		}
		return nil
	}

	private func visitSinglePipeline(statement stmt: KHSingleStatement,  pipelineStatement parent: KHPipelineStatement) {
		let pid   = stmt.processId
		let ecode = exitCode(parent)
		/* generate code for the statement */
		let _ = accept(statement: stmt)
		/* statement to wait process */
		add(statement: "\(ecode) = _waitUntilExitOne(_proc\(pid));")
	}

	private func visitMultiPipeline(statements stmts: Array<KHSingleStatement>, pipelineStatement parent: KHPipelineStatement) {
		/* Initial exit value */
		let ecode = exitCode(parent)
		add(statement: "let \(ecode) = 0 ;")

		/* First process */
		let stmt0 = stmts[0]
		let pid0  = stmt0.processId
		let pipe0 = pipeName(stmt0)
		add(statement: "let \(pipe0) = Pipe();")
		/* Update connection */
		if stmt0.inputName == nil {
			stmt0.inputName	= parent.inputNameString
		}
		stmt0.outputName = pipe0
		if stmt0.errorName == nil {
			stmt0.errorName = parent.errorNameString
		}
		/* Convert */
		let _ = accept(statement: stmt0)

		/* 2nd, 3rd process */
		var prevpid = pid0
		for i in 1..<stmts.count-1 {
			let stmtI = stmts[i]
			let pidI  = stmtI.processId
			let pipeI = pipeName(stmtI)
			add(statement: "let \(pipeI) = Pipe();")
			stmtI.inputName  = "_pipe\(prevpid)"
			stmtI.outputName = "_pipe\(pidI)"
			if stmtI.errorName == nil {
				stmtI.errorName = parent.errorNameString
			}
			/* Convert */
			let _ = accept(statement: stmtI)
			prevpid = pidI
		}

		/* Last process */
		let stmtN = stmts[stmts.count-1]
		stmtN.inputName  = "_pipe\(prevpid)"
		if stmtN.outputName == nil {
			stmtN.outputName = parent.outputNameString
		}
		if stmtN.errorName == nil {
			stmtN.errorName  = parent.errorNameString
		}
		let _ = accept(statement: stmtN)

		/* Wait all process */
		var is1stwait = true
		var waitprocs  = "["
		for stmt in stmts {
			if is1stwait {
				is1stwait = false
			} else {
				waitprocs += ", "
			}
			waitprocs += processName(stmt)
		}
		waitprocs += "] "

		add(statement: "\(ecode) = _waitUntilExitAll(\(waitprocs)) ;\n")
	}

	open override func visit(multiStatements stmts: KHMultiStatements) -> KHMultiStatements? {
		add(statement: "do {")
		incIndent()
			for stmt in stmts.pipelineStatements {
				let _ = accept(statement: stmt)
			}
		decIndent()
		add(statement: "} while(false) ;")
		return nil
	}
}

