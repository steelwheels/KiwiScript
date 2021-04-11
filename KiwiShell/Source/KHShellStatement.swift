/**
 * @file	KHShellCommand.swift
 * @brief	Define KHShellCommand class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import KiwiLibrary
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
}

open class KHSingleStatement: KHStatement
{
	public var inputName:	String?
	public var outputName:	String?
	public var errorName:	String?

	public var inputNameString:  String { get { return select(inputName,  KLFile.StdInName) }}
	public var outputNameString: String { get { return select(outputName, KLFile.StdOutName) }}
	public var errorNameString:  String { get { return select(errorName,  KLFile.StdErrName) }}

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
}

public class KHScriptStatement: KHSingleStatement
{
	private var mScript:		Array<String>

	public var script: Array<String> { get { return mScript }}

	public init(script scr: Array<String>){
		mScript 	= scr
	}
}

public class KHShellCommandStatement: KHSingleStatement
{
	private var mShellCommand:	String

	public var shellCommand: String { get { return mShellCommand }}

	public init(shellCommand cmd: String){
		mShellCommand	= cmd
	}
}

public class KHCdCommandStatement: KHSingleStatement
{
	private var mPath:	String?

	public var path: String? { get { return mPath }}

	public init(path pth: String?) {
		mPath = pth
	}
}

public class KHHistoryCommandStatement: KHSingleStatement
{
	public static let commandName: String = "_historyCommand"

	public override init() {
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
}

public class KHInstallCommandStatement: KHSingleStatement
{
	private var mScriptPath:	String?
	private var mArgument:		String?

	public var scriptPath: String? { get { return mScriptPath }}
	public var argument:   String? { get { return mArgument   }}

	public init(scriptPath path: String?, argument arg: String?) {
		mScriptPath = path
		mArgument   = arg
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
}


