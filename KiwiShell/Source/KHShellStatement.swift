/**
 * @file	KHShellCommand.swift
 * @brief	Define KHShellCommand class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import CoconutShell
import Foundation

private let	LocalExitName:String	= "_extval"

public extension CNSystemShellCommandStatement
{
	func toScript() -> Array<String> {
		let system = "let _proc\(processId) = system(`\(shellCommand)`, \(self.inputNameString), \(self.outputNameString), \(self.errorNameString)) ;"
		return [system]
	}
}

public extension CNRunShellCommandStatement
{
	func toScript() -> Array<String> {
		let path  = self.scriptPath
		let stmt0 = "let _proc\(processId) = run(\(path), \(self.inputNameString), \(self.outputNameString), \(self.errorNameString)) ;"
		let stmt1 = "_proc\(processId).start([]) ;"
		return [stmt0, stmt1]
	}
}

public extension CNBuiltinShellCommandStatement
{
	func toScript() -> Array<String> {
		let url   = self.scriptURL
		let stmt0 = "let _proc\(processId) = run(\"\(url.path)\", \(self.inputNameString), \(self.outputNameString), \(self.errorNameString)) ;"
		let stmt1 = "_proc\(processId).start([]) ;"
		return [stmt0, stmt1]
	}
}

public extension CNProcessShellStatement
{
	func toScript() -> Array<String> {
		let result: Array<String>
		let sequence = self.commandSequence
		switch sequence.count {
		case 0:
			result = []
		case 1:
			result = convetToScript(statement: sequence[0])
		default:
			var scr: Array<String> = []
			let num = sequence.count
			for i in 0..<num {
				let subscr = convetToScript(statement: sequence[i])
				scr.append(contentsOf: subscr)
				if i < num-1 {
					let procid   = sequence[i].processId
					let waitstmt = "\(LocalExitName) = _select_exit_code(_proc\(procid).waitUntilExit(), \(LocalExitName)) ;"
					scr.append(waitstmt)
				}
			}
			result = scr
		}
		return result
	}

	private func convetToScript(statement stmt: CNShellCommandStatement) -> Array<String> {
		let result: Array<String>
		if let s = stmt as? CNSystemShellCommandStatement {
			result = s.toScript()
		} else if let s = stmt as? CNRunShellCommandStatement {
			result = s.toScript()
		} else if let s = stmt as? CNBuiltinShellCommandStatement {
			result = s.toScript()
		} else {
			result = ["<<No matched class>>"]
		}
		return result
	}
}

public extension CNPipelineShellStatement
{
	func toScript() -> Array<String> {
		let processes = self.commandProcesses
		let result: Array<String>
		switch processes.count {
		case 0:
			result = []
		case 1:
			var stmts: Array<String> = []
			let proc = processes[0]
			let pid  = proc.processId
			/* statememt to allocate process */
			stmts.append(contentsOf: proc.toScript())
			/* statement to wait process */
			if let ename = exitName {
				stmts.append("\(ename) = _proc\(pid).waitUntilExit() ;")
			} else {
				stmts.append("_proc\(pid).waitUntilExit() ;")
			}
			result = stmts
		default: // count >= 2
			var stmts: Array<String> = []
			let count  = processes.count

			/* Initial exit value */
			stmts.append("let \(LocalExitName) = 0 ;")

			/* First process */
			let proc0 = processes[0]
			let pid0  = proc0.processId
			stmts.append("let _pipe\(pid0) = Pipe();")
			if proc0.inputName == nil {
				proc0.inputName	 = self.inputNameString
			}
			proc0.outputName = "_pipe\(pid0)"
			if proc0.errorName == nil {
				proc0.errorName  = self.errorNameString
			}
			stmts.append(contentsOf: proc0.toScript())

			/* 2nd, 3rd process */
			var prevpid = pid0
			for i in 1..<count-1 {
				let procI = processes[i]
				let pidI  = procI.processId
				stmts.append("let _pipe\(pidI) = Pipe();")
				procI.inputName  = "_pipe\(prevpid)"
				procI.outputName = "_pipe\(pidI)"
				if procI.errorName == nil {
					procI.errorName  = self.errorNameString
				}
				stmts.append(contentsOf: procI.toScript())
				prevpid = pidI
			}

			/* Last process */
			let procN = processes[count-1]
			procN.inputName  = "_pipe\(prevpid)"
			if procN.outputName == nil {
				procN.outputName = self.outputNameString
			}
			if procN.errorName == nil {
				procN.errorName  = self.errorNameString
			}
			stmts.append(contentsOf: procN.toScript())

			/* Wait all process */
			var is1stwait = true
			var waitprocs  = "["
			for proc in processes {
				if is1stwait {
					is1stwait = false
				} else {
					waitprocs += ", "
				}
				waitprocs += "_proc\(proc.processId)"
			}
			waitprocs += "] "
			stmts.append("for(let proc of \(waitprocs)){")
			stmts.append("\t\(LocalExitName) = _select_exit_code(proc.waitUntilExit(), \(LocalExitName)) ;")
			stmts.append("}")

			/* Assign exit value */
			if let ename = exitName {
				stmts.append("\(ename) = \(LocalExitName) ;")
			}

			result = stmts
		}
		return result
	}
}
