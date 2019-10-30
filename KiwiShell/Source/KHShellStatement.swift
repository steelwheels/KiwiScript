/**
 * @file	KHShellStatement.swift
 * @brief	Define KHShellStatement class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KHShellCommand
{
	public var 	command:	String
	public var	inputName:	String?
	public var	outputName:	String?
	public var	errorName:	String?

	public init(command cmd: String) {
		command		= cmd
		inputName	= nil
		outputName	= nil
		errorName	= nil
	}

	public func check() -> NSError? {
		if command.isEmpty {
			return NSError.parseError(message: "No command")
		} else {
			return nil
		}
	}

	public func compile() -> NSError? {
		if let err = decodeRedirect() {
			return err
		}
		return nil
	}

	private func decodeRedirect() -> NSError? {
		var modcmd = ""
		var idx    = command.startIndex
		let endidx = command.endIndex
		while idx < endidx {
			let c = command[idx]
			switch c {
			case "2":
				let nextidx = command.index(after: idx)
				if nextidx < endidx && command[nextidx] == ">" {
					if let (next2idx, pipe) = decodePipe(index: nextidx) {
						idx = next2idx ; errorName = pipe
						continue
					}
				}
			case ">":
				if let (nextidx, pipe) = decodePipe(index: idx) {
					idx = nextidx ; outputName = pipe
					continue
				}
			case "<":
				if let (nextidx, pipe) = decodePipe(index: idx) {
					idx = nextidx ; inputName = pipe
					continue
				}
			default:
				break
			}
			/* append 1 char */
			idx = command.index(after: idx)
			modcmd.append(c)
		}
		/* Replace command */
		self.command = modcmd
		return nil
	}

	private func decodePipe(index startidx: String.Index) -> (String.Index, String)? {
		var idx    = command.index(after: startidx)
		let endidx = command.endIndex

		/* Skip idx */
		while idx<endidx {
			let c = command[idx]
			if !c.isSpace() {
				break
			}
			idx = command.index(after: idx)
		}
		/* Get "@" */
		if idx<endidx && command[idx] == "@" {
			var nidx = command.index(after: idx)
			if nidx < endidx {
				var name = ""
				while nidx < endidx {
					let c = command[nidx]
					if c.isAlphaOrNum() {
						name.append(c)
					} else {
						break
					}
					nidx = command.index(after: nidx)
				}
				if name.lengthOfBytes(using: .utf8) > 0 {
					return (nidx, name)
				}
			}
		}
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
		/* Compile for each commands */
		for cmd in commands {
			if let err = cmd.compile() {
				return err
			}
		}
		/* Get pipe names */
		for cmd in commands {
			if let inname = cmd.inputName {
				if let orgname = self.inputName {
					return NSError.parseError(message: "Multiple input pipe: \(orgname), \(inname)")
				} else {
					self.inputName = inname
				}
			}
			if let outname = cmd.outputName {
				if let orgname = self.outputName {
					return NSError.parseError(message: "Multiple output pipe: \(orgname), \(outname)")
				} else {
					self.outputName = outname
				}
			}
			if let errname = cmd.errorName {
				if let orgname = self.errorName {
					return NSError.parseError(message: "Multiple error pipe: \(orgname), \(errname)")
				} else {
					self.errorName = errname
				}
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
	public var processes:		Array<KHShellProcess>
	public var indent:		String
	public var insertedPipeNames:	Array<String>

	public init(indent idt: String){
		processes 		= []
		indent    		= idt
		insertedPipeNames	= []
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
		/* First, compile processes */
		for proc in processes {
			if let err = proc.compile() {
				return err
			}
		}
		setUniqueIds()
		if let err = insertPipes() {
			return err
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

	private func insertPipes() -> NSError? {
		insertedPipeNames = []
		let procnum = processes.count
		if procnum >= 2 {
			for i in 0..<procnum-1 {
				let procA = processes[i  ]
				let procB = processes[i+1]
				let pipe  = "_pipe\(procA.processId)"
				if let name = procA.outputName {
					return NSError.parseError(message: "The output stream is already defined: \(name)")
				} else {
					procA.outputName = pipe
				}
				if let name = procB.inputName {
					return NSError.parseError(message: "The input stream is already defined: \(name)")
				} else {
					procB.inputName  = pipe
				}
				insertedPipeNames.append(pipe)
			}
		}
		return nil
	}

	public func toScript() -> Array<String> {
		var result: Array<String> = []
		result.append(indent + "do {")

		/* Define pipes */
		let nidt = indent + "\t"
		for name in insertedPipeNames {
			let stmt = "let \(name) = Pipe() ;"
			result.append(nidt + stmt)
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

