/**
 * @file	KHShellStatement.swift
 * @brief	Define KHShellStatement class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import Foundation

public class KHShellCommand
{
	public var 	command:	String

	public init(command cmd: String) {
		command = cmd
	}

	public func check() -> NSError? {
		if command.isEmpty {
			return NSError.parseError(message: "No command")
		} else {
			return nil
		}
	}

	public func compile() -> NSError? {
		return nil
	}

	public func toScript() -> String {
		return command
	}
}

public class KHShellProcess
{
	public var 	commands:	Array<KHShellCommand>
	public var	processId:	Int
	public var	inputName:	String?
	public var	outputName:	String?
	public var	errorName:	String?

	public init(){
		commands = []
		processId	= 0
		inputName	= nil
		outputName	= nil
		errorName	= nil
	}

	public func add(command cmd: KHShellCommand){
		commands.append(cmd)
	}

	public func check() -> NSError? {
		if commands.count > 0 {
			for cmd in commands {
				if let err = cmd.check() {
					return err
				}
			}
			return nil
		} else {
			return NSError.parseError(message: "No command")
		}
	}

	public func compile() -> NSError? {
		for cmd in commands {
			if let err = cmd.compile() {
				return err
			}
		}
		return nil
	}

	public func toScript() -> String {
		/* Make command */
		var cmdstr: String	= ""
		var is1st:  Bool	= true
		for cmd in commands {
			if is1st {
				is1st = false
			} else {
				cmdstr += " ; "
			}
			cmdstr += cmd.toScript()
		}
		/* Make function call */
		let instr, outstr, errstr: String
		if let str = inputName  { instr  = str } else { instr  = "stdin"  }
		if let str = outputName { outstr = str } else { outstr = "stdout" }
		if let str = errorName  { errstr = str } else { errstr = "stderr" }
		let system = "let _proc\(processId) = system(`\(cmdstr)`, \(instr), \(outstr), \(errstr)) ;"
		return system
	}
}

public class KHShellStatements
{
	public var processes:	Array<KHShellProcess>
	public var indent:	String

	public init(indent idt: String){
		processes = []
		indent    = idt
	}

	public func add(process proc: KHShellProcess){
		processes.append(proc)
	}

	public func check() -> NSError? {
		if processes.count > 0 {
			for proc in processes {
				if let err = proc.check() {
					return err
				}
			}
			return nil
		} else {
			return NSError.parseError(message: "No processes")
		}
	}

	public func compile() -> NSError? {
		setUniqueIds()
		insertPipes()
		for proc in processes {
			if let err = proc.compile() {
				return err
			}
		}
		return nil
	}

	private func setUniqueIds() {
		/* set unique ids */
		var pid: Int = 0
		for proc in processes {
			proc.processId = pid
			pid += 1
		}
	}

	private func insertPipes() {
		let procnum = processes.count
		if procnum >= 2 {
			for i in 0..<procnum-1 {
				let procA = processes[i  ]
				let procB = processes[i+1]
				let pipe  = "_pipe\(procA.processId)"
				procA.outputName = pipe
				procB.inputName  = pipe
			}
		}
	}

	public func toScript() -> Array<String> {
		var result: Array<String> = []
		result.append(indent + "do {")

		/* Define pipes */
		let nidt = indent + "\t"
		for proc in processes {
			if let outname = proc.outputName {
				let stmt = "let \(outname) = Pipe() ;"
				result.append(nidt + stmt)
			}
		}

		/* Define processes */
		for proc in processes {
			let stmt = proc.toScript()
			result.append(nidt + stmt)
		}

		/* Insert waits */
		for proc in processes {
			let stmt = "_proc\(proc.processId).waitUntilExit() ;"
			result.append(nidt + stmt)
		}

		result.append(indent + "} while(false) ;")
		return result
	}
}

