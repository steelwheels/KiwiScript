/**
 * @file	KECompiler.swift
 * @brief	Define KECompiler class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import CoconutData
import JavaScriptCore
import Foundation

public enum KECompileError: Error
{
	case SyntaxError(String)	// error message

	public func toObject() -> NSError {
		var message: String
		switch self {
		case .SyntaxError(let msg):
			message = "Syntax error: \(msg)"
		}
		return NSError.parseError(message: message)
	}
}

public protocol KEConfig
{
	var doVerbose: Bool { get set }
}

open class KECompiler
{
	private var mContext		: KEContext
	private var mConsole		: CNConsole
	private var mConfig		: KEConfig

	public init(context ctxt: KEContext, console cons: CNConsole, config conf: KEConfig){
		mContext	= ctxt
		mConsole	= cons
		mConfig		= conf
	}

	public var context: KEContext { get { return mContext }}
	public var console: CNConsole { get { return mConsole }}
	public var config:  KEConfig  { get { return mConfig  }}

	public func log(string str: String) {
		if mConfig.doVerbose {
			mConsole.print(string: str)
		}
	}

	public func defineSetter(instance inst:String, accessType access: CNAccessType, propertyName name:String){
		if access.isReadable {
			let stmt = "\(inst).__defineGetter__(\"\(name)\", function(   ){ return this.get(\"\(name)\"     ); }) ;\n"
			let _ = compile(statement: stmt)
		}
		if access.isWritable {
			let stmt = "\(inst).__defineSetter__(\"\(name)\", function(val){ return this.set(\"\(name)\", val); }) ;\n"
			let _ = compile(statement: stmt)
		}
	}

	public func compile(statement stmt: String) -> JSValue? {
		log(string: stmt)
		return mContext.evaluateScript(stmt)
	}

	public func compile(statements stmts: Array<String>) -> JSValue? {
		var addedstmt: String = ""
		for stmt in stmts {
			if mConfig.doVerbose {
				mConsole.print(string: stmt)
			}
			addedstmt = addedstmt + stmt + "\n"
		}
		return mContext.evaluateScript(addedstmt)
	}
}
