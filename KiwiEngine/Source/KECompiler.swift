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

	public init(application app: KEApplication){
		mApplication	= app
	}

	public var application: KEApplication { get { return mApplication }}

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
			mApplication.console.print(string: str)
		}
	}

	public func error(message msg: String){
		let except = KEException.CompileError(msg)
		mApplication.context.exceptionCallback(except)
	}

	public func defineGlobalVariable(variableName name: String, object obj: JSExport){
		mApplication.context.set(name: name, object: obj)
	}

	public func defineGlobalVariable(variableName name: String, value val: JSValue){
		mApplication.context.set(name: name, value: val)
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
		return mApplication.context.evaluateScript(stmt)
	}

	public func compile(statements stmts: Array<String>) -> JSValue? {
		var addedstmt: String = ""
		for stmt in stmts {
			log(string: stmt)
			addedstmt = addedstmt + stmt + "\n"
		}
		return mApplication.context.evaluateScript(addedstmt)
	}

	public func compile(enumObject eobj: KEObject, enumTable etable: KEObject){
		/* Compile */
		let instname = eobj.instanceName
		log(string: "/* Define Enum: \(instname) */\n")
		mApplication.context.set(name: instname, object: eobj.propertyTable)
		let members = eobj.propertyTable.propertyNames
		for member in members {
			defineSetter(instance: instname, accessType: .ReadOnlyAccess, propertyName: member)
		}
		/* Store to enum table */
		etable.set(name: instname, object: .Object(eobj))
	}
}
