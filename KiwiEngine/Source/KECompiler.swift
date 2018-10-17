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
	private var mProcess:		KEProcess
	public var doVerbose:		Bool

	public init(process proc: KEProcess){
		mProcess	= proc
		doVerbose	= true
	}

	public var process: KEProcess { get { return mProcess }}
	
	public func log(string str: String) {
		if doVerbose {
			mProcess.console.print(string: str)
		}
	}

	public func error(message msg: String){
		let except = KEException.CompileError(msg)
		mProcess.context.exceptionCallback(except)
	}

	public func defineGlobalVariable(variableName name: String, object obj: JSExport){
		mProcess.context.set(name: name, object: obj)
	}

	public func defineGlobalVariable(variableName name: String, value val: JSValue){
		mProcess.context.set(name: name, value: val)
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
		return mProcess.context.evaluateScript(stmt)
	}

	public func compile(statements stmts: Array<String>) -> JSValue? {
		var addedstmt: String = ""
		for stmt in stmts {
			log(string: stmt)
			addedstmt = addedstmt + stmt + "\n"
		}
		return mProcess.context.evaluateScript(addedstmt)
	}

	public func compile(enumObject eobj: KEObject, enumTable etable: KEObject){
		/* Compile */
		let instname = eobj.instanceName
		log(string: "/* Define Enum: \(instname) */\n")
		mProcess.context.set(name: instname, object: eobj.propertyTable)
		let members = eobj.propertyTable.propertyNames
		for member in members {
			defineSetter(instance: instname, accessType: .ReadOnlyAccess, propertyName: member)
		}
		/* Store to enum table */
		etable.set(name: instname, object: .Object(eobj))
	}
}
