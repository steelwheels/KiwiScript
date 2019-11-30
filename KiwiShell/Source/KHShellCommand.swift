/**
 * @file	KHShellCommand.swift
 * @brief	Define KHShellCommand class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import Foundation

private let	NoProcessId: Int	= 0
private let	LocalExitName:String	= "_extval"

public protocol KHStatementProtocol {
	var	processId:	Int	 { get 	   }
	var	inputName:	String?	 { get set }
	var	outputName:	String?  { get set }
	var	errorName:	String?  { get set }

	func toScript() -> Array<String>
}

extension KHStatementProtocol {
	var inputNameString: String {
		if let str = self.inputName {
			return str
		} else {
			return "stdin"
		}
	}
	var outputNameString: String {
		if let str = self.outputName {
			return str
		} else {
			return "stdout"
		}
	}
	var errorNameString: String {
		if let str = self.errorName {
			return str
		} else {
			return "stderr"
		}
	}
}

public class KHCommandStatement: KHStatementProtocol
{
	private var	mProcessId:	Int

	public var	inputName:	String?
	public var	outputName:	String?
	public var	errorName:	String?

	public var processId: Int { get { return mProcessId }}

	public init() {
		mProcessId	= NoProcessId
		inputName	= nil
		outputName	= nil
		errorName	= nil
	}

	public func updateProcessId(startId pid: Int) -> Int {
		mProcessId = pid
		return pid + 1
	}

	open func toScript() -> Array<String> {
		return ["MUST BE OVERRIDE"]
	}
}


public class KHShellCommandStatement: KHCommandStatement
{
	private var shellCommand:	String

	public init(shellCommand cmd: String){
		shellCommand	= cmd
		super.init()
	}

	public override func toScript() -> Array<String> {
		let system = "let _proc\(processId) = system(`\(shellCommand)`, \(self.inputNameString), \(self.outputNameString), \(self.errorNameString)) ;"
		return [system]
	}
}

public class KHRunCommandStatement: KHCommandStatement
{
	private var mScriptPath:	String?

	public init(scriptPath path: String?) {
		mScriptPath = path
		super.init()
	}

	public override func toScript() -> Array<String> {
		let path: String
		if let p = mScriptPath {
			path = "\"\(p)\""
		} else {
			path = "null"
		}
		let stmt0 = "let _proc\(processId) = run(\(path), \(self.inputNameString), \(self.outputNameString), \(self.errorNameString)) ;"
		let stmt1 = "_proc\(processId).start() ;"
		return [stmt0, stmt1]
	}
}

public class KHProcessStatement: KHStatementProtocol
{
	private var mCommandSequence:	Array<KHCommandStatement>

	public var processId: Int {
		get {
			/* Get last process id */
			let count = mCommandSequence.count
			if count > 0 {
				return mCommandSequence[count - 1].processId
			} else {
				NSLog("No process id")
				return 0
			}
		}
	}

	public init(){
		mCommandSequence = []
	}

	public var inputName: String? {
		get {
			if mCommandSequence.count > 0 {
				return mCommandSequence[0].inputName
			} else {
				return nil
			}
		}
		set(newname){
			for cmd in mCommandSequence {
				cmd.inputName = newname
			}
		}
	}

	public var outputName: String? {
		get {
			if mCommandSequence.count > 0 {
				return mCommandSequence[0].outputName
			} else {
				return nil
			}
		}
		set(newname){
			for cmd in mCommandSequence {
				cmd.outputName = newname
			}
		}
	}

	public var errorName: String? {
		get {
			if mCommandSequence.count > 0 {
				return mCommandSequence[0].errorName
			} else {
				return nil
			}
		}
		set(newname){
			for cmd in mCommandSequence {
				cmd.errorName = newname
			}
		}
	}

	public func add(command cmd: KHCommandStatement){
		mCommandSequence.append(cmd)
	}

	public func updateProcessId(startId pid: Int) -> Int {
		var newpid = pid
		for cmd in mCommandSequence {
			newpid = cmd.updateProcessId(startId: newpid)
		}
		return newpid
	}

	public func toScript() -> Array<String> {
		let result: Array<String>
		switch mCommandSequence.count {
		case 0:
			result = []
		case 1:
			result = mCommandSequence[0].toScript()
		default:
			var scr: Array<String> = []
			let num = mCommandSequence.count
			for i in 0..<num {
				let subscr = mCommandSequence[i].toScript()
				scr.append(contentsOf: subscr)
				if i < num-1 {
					let procid   = mCommandSequence[i].processId
					let waitstmt = "\(LocalExitName) = _select_exit_code(_proc\(procid).waitUntilExit(), \(LocalExitName)) ;"
					scr.append(waitstmt)
				}
			}
			result = scr
		}
		return result
	}
}

public class KHPipelineStatement: KHStatementProtocol
{
	private var  	mProcessId:	Int

	public var	inputName: 	String?
	public var	outputName:	String?
	public var	errorName:	String?
	public var	exitName:	String?

	private var 	mCommandProcesses:	Array<KHProcessStatement>

	public var processId: Int { get { return mProcessId }}

	public init(){
		mProcessId		= NoProcessId
		inputName		= nil
		outputName		= nil
		errorName		= nil
		mCommandProcesses	= []
	}

	public func add(process proc: KHProcessStatement){
		mCommandProcesses.append(proc)
		let _ = updateProcessId(startId: 0)
	}

	public func updateProcessId(startId pid: Int) -> Int {
		var newpid = pid
		for proc in mCommandProcesses {
			newpid = proc.updateProcessId(startId: newpid)
		}
		mProcessId = newpid
		return newpid + 1
	}

	public func toScript() -> Array<String> {
		let result: Array<String>
		switch mCommandProcesses.count {
		case 0:
			result = []
		case 1:
			var stmts: Array<String> = []
			let proc = mCommandProcesses[0]
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
			let count  = mCommandProcesses.count

			/* Initial exit value */
			stmts.append("let \(LocalExitName) = 0 ;")

			/* First process */
			let proc0 = mCommandProcesses[0]
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
				let procI = mCommandProcesses[i]
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
			let procN = mCommandProcesses[count-1]
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
			for proc in mCommandProcesses {
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
