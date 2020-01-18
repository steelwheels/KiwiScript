/**
 * @file	KHShellCommand.swift
 * @brief	Define KHShellCommand class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import CoconutData
import Foundation

private let	NoProcessId: Int	= 0

open class KHStatement
{
	public var 	processId:	Int

	public init(){
		processId = NoProcessId
	}

	public func copyProperties(toStatement stmt: KHStatement){
		stmt.processId = self.processId
	}

	open func dump(indent idt: Int, to console: CNConsole) {
	}

	public func indentToString(indent idt: Int) -> String {
		return String(repeating: "  ", count: idt)
	}
}

open class KHSingleStatement: KHStatement
{
	public var inputName:	String?
	public var outputName:	String?
	public var errorName:	String?

	public var inputNameString:  String { get { return select(inputName,  "stdin") }}
	public var outputNameString: String { get { return select(outputName, "stdout") }}
	public var errorNameString:  String { get { return select(errorName,  "stderr") }}

	public var exitCodeString: String { get { return "_ecode\(self.processId)" }}

	public override init(){
		inputName	= nil
		outputName	= nil
		errorName	= nil
	}

	private func select(_ str0: String?, _ str1: String) -> String {
		if let str = str0 {
			return str
		} else {
			return str1
		}
	}

	open override func dump(indent idt: Int, to console: CNConsole) {
		super.dump(indent: idt, to: console)

		let spaces = indentToString(indent: idt)
		console.print(string: spaces + "input-file:  \(inputNameString)\n")
		console.print(string: spaces + "output-file: \(outputNameString)\n")
		console.print(string: spaces + "error-file:  \(errorNameString)\n")
	}
}

public class KHScriptStatement: KHSingleStatement
{
	private var mScript:		Array<String>

	public var script: Array<String> { get { return mScript }}

	public init(script scr: Array<String>){
		mScript 	= scr
	}

	open override func dump(indent idt: Int, to console: CNConsole) {
		let spaces0 = indentToString(indent: idt)
		let spaces1 = indentToString(indent: idt+1)
		console.print(string: spaces0 + "script: {\n")
		super.dump(indent: idt+1, to: console)
		console.print(string: spaces1 + "script:  \"\(mScript)\"\n")
		console.print(string: spaces0 + "}\n")
	}
}

public class KHShellCommandStatement: KHSingleStatement
{
	private var mShellCommand:	String

	public var shellCommand: String { get { return mShellCommand }}

	public init(shellCommand cmd: String){
		mShellCommand	= cmd
	}

	open override func dump(indent idt: Int, to console: CNConsole) {
		let spaces0 = indentToString(indent: idt)
		let spaces1 = indentToString(indent: idt+1)
		console.print(string: spaces0 + "shell-command: {\n")
		super.dump(indent: idt+1, to: console)
		console.print(string: spaces1 + "command:  \"\(mShellCommand)\"\n")
		console.print(string: spaces0 + "}\n")
	}
}

public class KHRunCommandStatement: KHSingleStatement
{
	private var mScriptPath:	String?

	public var scriptPath: String? { get { return mScriptPath }}

	public init(scriptPath path: String?) {
		mScriptPath = path
	}

	open override func dump(indent idt: Int, to console: CNConsole) {
		let spaces0 = indentToString(indent: idt)
		let spaces1 = indentToString(indent: idt)
		console.print(string: spaces0 + "run-command: {\n")
		super.dump(indent: idt+1, to: console)
		let path: String
		if let p = mScriptPath {
			path = p
		} else {
			path = "<nil>"
		}
		console.print(string: spaces1 + "run:  \"\(path)\"\n")
		console.print(string: spaces0 + "}\n")
	}
}

public class KHBuiltinCommandStatement: KHSingleStatement
{
	private var mScriptURL:	URL
	private var mArguments:	Array<String>

	public var scriptURL: URL { get { return mScriptURL }}
	public var arguments: Array<String> { get { return mArguments }}

	public init(scriptURL url: URL, arguments args: Array<String>) {
		mScriptURL = url
		mArguments = args
	}

	open override func dump(indent idt: Int, to console: CNConsole) {
		let spaces0 = indentToString(indent: idt)
		let spaces1 = indentToString(indent: idt)
		console.print(string: spaces0 + "builtin: {\n")
		super.dump(indent: idt+1, to: console)
		console.print(string: spaces1 + "script-url:  \"\(mScriptURL.path)\"\n")
		console.print(string: spaces0 + "}\n")
	}
}

public class KHPipelineStatement: KHSingleStatement
{
	private var  mSingleStatements:	Array<KHSingleStatement>

	public var singleStatements: 	Array<KHSingleStatement> { get { return mSingleStatements }}
	public var exitCode:		String?

	public override init(){
		mSingleStatements = []
	}

	public func add(statement stmt: KHSingleStatement){
		mSingleStatements.append(stmt)
	}

	public func copyProperties(toPipelineStatement stmt: KHPipelineStatement){
		super.copyProperties(toStatement: stmt)
	}

	open override func dump(indent idt: Int, to console: CNConsole) {
		let spaces = indentToString(indent: idt)
		console.print(string: spaces + "pipeline: {\n")
		super.dump(indent: idt+1, to: console)
		console.print(string: spaces + "exit-code:  \(exitCodeString)\n")
		for stmt in singleStatements {
			stmt.dump(indent: idt+1, to: console)
		}
		console.print(string: spaces + "}\n")
	}
}

public class KHMultiStatements: KHStatement
{
	private var mPipelineStatements:	Array<KHPipelineStatement>

	public var pipelineStatements: Array<KHPipelineStatement> { get { return mPipelineStatements }}

	public override init(){
		mPipelineStatements = []
	}

	public func add(statement stmt: KHPipelineStatement){
		mPipelineStatements.append(stmt)
	}

	public func copyProperties(toMultiStatements stmts: KHMultiStatements){
		super.copyProperties(toStatement: stmts)
	}

	open override func dump(indent idt: Int, to console: CNConsole) {
		let spaces = indentToString(indent: idt)
		console.print(string: spaces + "multi: {\n")
		super.dump(indent: idt+1, to: console)
		for stmt in pipelineStatements {
			stmt.dump(indent: idt+1, to: console)
		}
		console.print(string: spaces + "}\n")
	}
}


/*
public protocol KHStatement {
	var	processId:	Int	 { get set }
	var	inputName:	String?	 { get set }
	var	outputName:	String?  { get set }
	var	errorName:	String?  { get set }

	func toScript(indent idt: String) -> Array<String>
}

extension KHStatement {
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

private func insertIndent(statements stmts: Array<String>, indent idt: String) -> Array<String> {
	var result: Array<String> = []
	for stmt in stmts {
		result.append(idt + stmt)
	}
	return result
}

public class KHScriptStatement: KHStatement
{
	public var processId:		Int
	public var inputName:		String?
	public var outputName:		String?
	public var errorName:		String?

	private var mScript:		Array<String>

	public init(script scr: Array<String>){
		inputName	= nil
		outputName	= nil
		errorName	= nil
		processId	= NoProcessId
		mScript 	= scr
	}

	public func toScript(indent idt: String) -> Array<String> {
		return insertIndent(statements: mScript, indent: idt)
	}
}

public class KHCommandStatement: KHStatement
{
	public var	processId:	Int
	public var	inputName:	String?
	public var	outputName:	String?
	public var	errorName:	String?

	public init() {
		processId	= NoProcessId
		inputName	= nil
		outputName	= nil
		errorName	= nil
	}

	open func toScript(indent idt: String) -> Array<String> {
		return [idt+"MUST BE OVERRIDE"]
	}
}


public class KHShellCommandStatement: KHCommandStatement
{
	private var mShellCommand:	String

	public var shellCommand: String { get { return mShellCommand }}

	public init(shellCommand cmd: String){
		mShellCommand	= cmd
		super.init()
	}

	public override func toScript(indent idt: String) -> Array<String> {
		let system = "let _proc\(processId) = system(`\(mShellCommand)`, \(self.inputNameString), \(self.outputNameString), \(self.errorNameString)) ;"
		return [idt + system]
	}
}

public class KHRunCommandStatement: KHCommandStatement
{
	private var mScriptPath:	String?

	public var scriptPath: String? { get { return mScriptPath }}

	public init(scriptPath path: String?) {
		mScriptPath = path
		super.init()
	}

	public override func toScript(indent idt: String) -> Array<String> {
		let path: String
		if let p = mScriptPath {
			path = "\"\(p)\""
		} else {
			path = "null"
		}
		let stmt0 = "let _proc\(processId) = run(\(path), \(self.inputNameString), \(self.outputNameString), \(self.errorNameString)) ;"
		let stmt1 = "_proc\(processId).start([]) ;"
		let stmts = [stmt0, stmt1]
		return insertIndent(statements: stmts, indent: idt)
	}
}

public class KHBuiltinCommandStatement: KHCommandStatement
{
	private var mScriptURL:	URL

	public init(scriptURL url: URL) {
		mScriptURL = url
		super.init()
	}

	public override func toScript(indent idt: String) -> Array<String> {
		let stmt0 = "let _proc\(processId) = run(\"\(mScriptURL.path)\", \(self.inputNameString), \(self.outputNameString), \(self.errorNameString)) ;"
		let stmt1 = "_proc\(processId).start([]) ;"
		let stmts = [stmt0, stmt1]
		return insertIndent(statements: stmts, indent: idt)
	}
}

public class KHProcessStatement: KHStatement
{
	private var mCommandStatements:	Array<KHCommandStatement>

	public var processId: Int
	public var commandStatements: Array<KHCommandStatement> { get { return mCommandStatements }}

	public init(){
		processId	   = NoProcessId
		mCommandStatements = []
	}

	public var inputName: String? {
		get {
			if mCommandStatements.count > 0 {
				return mCommandStatements[0].inputName
			} else {
				return nil
			}
		}
		set(newname){
			for cmd in mCommandStatements {
				cmd.inputName = newname
			}
		}
	}

	public var outputName: String? {
		get {
			if mCommandStatements.count > 0 {
				return mCommandStatements[0].outputName
			} else {
				return nil
			}
		}
		set(newname){
			for cmd in mCommandStatements {
				cmd.outputName = newname
			}
		}
	}

	public var errorName: String? {
		get {
			if mCommandStatements.count > 0 {
				return mCommandStatements[0].errorName
			} else {
				return nil
			}
		}
		set(newname){
			for cmd in mCommandStatements {
				cmd.errorName = newname
			}
		}
	}

	public func add(command cmd: KHCommandStatement){
		mCommandStatements.append(cmd)
	}

	public func toScript(indent idt: String) -> Array<String> {
		let result: Array<String>
		switch mCommandStatements.count {
		case 0:
			result = []
		case 1:
			result = mCommandStatements[0].toScript(indent: idt)
		default:
			var scr: Array<String> = []
			let num = mCommandStatements.count
			for i in 0..<num {
				let subscr = mCommandStatements[i].toScript(indent: idt)
				scr.append(contentsOf: subscr)
				if i < num-1 {
					let procid   = mCommandStatements[i].processId
					let waitstmt = "\(LocalExitName) = _select_exit_code(_proc\(procid).waitUntilExit(), \(LocalExitName)) ;"
					scr.append(idt + waitstmt)
				}
			}
			result = scr
		}
		return result
	}

	public func duplicateWithoutSubStatements() -> KHProcessStatement {
		let newstmt = KHProcessStatement()
		newstmt.inputName	= self.inputName
		newstmt.outputName	= self.outputName
		newstmt.errorName	= self.errorName
		return newstmt
	}
}

public class KHPipelineStatement: KHStatement
{
	public var  	processId:	Int
	public var	inputName: 	String?
	public var	outputName:	String?
	public var	errorName:	String?
	public var	exitName:	String?

	private var 	mProcessStatements:	Array<KHProcessStatement>

	public var processStatements: Array<KHProcessStatement> { get { return mProcessStatements }}

	public init(){
		processId		= NoProcessId
		inputName		= nil
		outputName		= nil
		errorName		= nil
		mProcessStatements	= []
	}

	public func add(process proc: KHProcessStatement){
		mProcessStatements.append(proc)
	}

	public func toScript(indent idt: String) -> Array<String> {
		var newstmts: Array<String> = []
		newstmts.append(idt + "do {")
		newstmts.append(contentsOf: self.toScriptBody(indent: idt + "\t"))
		newstmts.append(idt + "} while(false) ;")
		return newstmts
	}

	private func toScriptBody(indent idt: String) -> Array<String> {
		let result: Array<String>
		switch mProcessStatements.count {
		case 0:
			result = []
		case 1:
			var stmts: Array<String> = []
			let proc = mProcessStatements[0]
			let pid  = proc.processId
			/* statememt to allocate process */
			stmts.append(contentsOf: proc.toScript(indent: ""))
			/* statement to wait process */
			if let ename = exitName {
				stmts.append("\(ename) = _proc\(pid).waitUntilExit() ;")
			} else {
				stmts.append("_proc\(pid).waitUntilExit() ;")
			}
			result = stmts
		default: // count >= 2
			var stmts: Array<String> = []
			let count  = mProcessStatements.count

			/* Initial exit value */
			stmts.append("let \(LocalExitName) = 0 ;")

			/* First process */
			let proc0 = mProcessStatements[0]
			let pid0  = proc0.processId
			stmts.append("let _pipe\(pid0) = Pipe();")
			if proc0.inputName == nil {
				proc0.inputName	 = self.inputNameString
			}
			proc0.outputName = "_pipe\(pid0)"
			if proc0.errorName == nil {
				proc0.errorName  = self.errorNameString
			}
			stmts.append(contentsOf: proc0.toScript(indent: ""))

			/* 2nd, 3rd process */
			var prevpid = pid0
			for i in 1..<count-1 {
				let procI = mProcessStatements[i]
				let pidI  = procI.processId
				stmts.append("let _pipe\(pidI) = Pipe();")
				procI.inputName  = "_pipe\(prevpid)"
				procI.outputName = "_pipe\(pidI)"
				if procI.errorName == nil {
					procI.errorName  = self.errorNameString
				}
				stmts.append(contentsOf: procI.toScript(indent: ""))
				prevpid = pidI
			}

			/* Last process */
			let procN = mProcessStatements[count-1]
			procN.inputName  = "_pipe\(prevpid)"
			if procN.outputName == nil {
				procN.outputName = self.outputNameString
			}
			if procN.errorName == nil {
				procN.errorName  = self.errorNameString
			}
			stmts.append(contentsOf: procN.toScript(indent: ""))

			/* Wait all process */
			var is1stwait = true
			var waitprocs  = "["
			for proc in mProcessStatements {
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
		return insertIndent(statements: result, indent: idt)
	}

	public func duplicateWithoutSubStatements() -> KHPipelineStatement {
		let newstmt = KHPipelineStatement()
		newstmt.inputName	= self.inputName
		newstmt.outputName	= self.outputName
		newstmt.errorName	= self.errorName
		return newstmt
	}
}
*/

