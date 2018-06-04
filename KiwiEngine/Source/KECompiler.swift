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

open class KECompiler
{
	private var mApplication	: KEApplication
	private var mContext		: KEContext
	private var mConsole		: CNConsole

	public init(application app: KEApplication){
		mApplication	= app
		mContext	= app.context
		mConsole	= app.console
	}

	public var application: KEApplication { get { return mApplication }}
	public var context: KEContext { get { return mContext }}
	public var console: CNConsole { get { return mConsole }}

	public var doVerbose: Bool {
		get {
			if let config = application.config {
				return config.doVerbose
			}
			return true
		}
	}

	public func log(string str: String) {
		if doVerbose {
			mConsole.print(string: str)
		}
	}

	public func defineGlobalVariable(variableName name: String, object obj: JSExport){
		log(string: "/* global variable: \(name) */\n")
		mContext.set(name: name, object: obj)
	}

	public func defineGlobalVariable(variableName name: String, value val: JSValue){
		log(string: "/* global variable: \(name) */\n")
		mContext.set(name: name, value: val)
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
			log(string: stmt)
			addedstmt = addedstmt + stmt + "\n"
		}
		return mContext.evaluateScript(addedstmt)
	}

	public func compile(enumObject eobj: KEObject, enumTable etable: KEObject){
		/* Compile */
		let instname = eobj.instanceName
		log(string: "/* Define Enum: \(instname) */\n")
		context.set(name: instname, object: eobj.propertyTable)
		let members = eobj.propertyTable.propertyNames
		for member in members {
			defineSetter(instance: instname, accessType: .ReadOnlyAccess, propertyName: member)
		}
		/* Store to enum table */
		etable.set(name: instname, object: eobj)
	}
}
