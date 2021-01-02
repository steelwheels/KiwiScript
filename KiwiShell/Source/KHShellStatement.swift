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

	open func importProperties(source stmt: KHStatement) {
		self.processId = stmt.processId
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

	open func importProperties(source stmt: KHSingleStatement) {
		super.importProperties(source: stmt)
		self.inputName  = stmt.inputName
		self.outputName = stmt.outputName
		self.errorName  = stmt.errorName
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

public class KHCdCommandStatement: KHSingleStatement
{
	private var mPath:	String?

	public var path: String? { get { return mPath }}

	public init(path pth: String?) {
		mPath = pth
	}

	open override func dump(indent idt: Int, to console: CNConsole) {
		let spaces0 = indentToString(indent: idt)
		let spaces1 = indentToString(indent: idt)
		console.print(string: spaces0 + "cd-command: {\n")
		super.dump(indent: idt+1, to: console)
		let path: String
		if let p = mPath {
			path = p
		} else {
			path = "<nil>"
		}
		console.print(string: spaces1 + "cd:  \"\(path)\"\n")
		console.print(string: spaces0 + "}\n")
	}
}

public class KHRunCommandStatement: KHSingleStatement
{
	private var mScriptPath:	String?
	private var mArgument:		String?

	public var scriptPath: String? { get { return mScriptPath }}
	public var argument:   String? { get { return mArgument   }}

	public init(scriptPath path: String?, argument arg: String?) {
		mScriptPath = path
		mArgument   = arg
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

public class KHSetupCommandStatement: KHSingleStatement
{
	private var mScriptPath:	String?
	private var mArgument:		String?

	public var scriptPath: String? { get { return mScriptPath }}
	public var argument:   String? { get { return mArgument   }}

	public init(scriptPath path: String?, argument arg: String?) {
		mScriptPath = path
		mArgument   = arg
	}

	open override func dump(indent idt: Int, to console: CNConsole) {
		let spaces0 = indentToString(indent: idt)
		let spaces1 = indentToString(indent: idt)
		console.print(string: spaces0 + "setup-command: {\n")
		super.dump(indent: idt+1, to: console)
		let path: String
		if let p = mScriptPath {
			path = p
		} else {
			path = "<nil>"
		}
		console.print(string: spaces1 + "setup:  \"\(path)\"\n")
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


