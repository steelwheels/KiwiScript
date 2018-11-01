/**
 * @file	KECompiler.swift
 * @brief	Define KECompiler class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import CoconutData
import JavaScriptCore
import Foundation

open class KECompiler
{
	private var mConsole:		CNConsole
	private var mConfig:		KEConfig

	public init(console cons: CNConsole, config conf: KEConfig){
		mConsole	= cons
		mConfig		= conf
	}

	open func compile(context ctxt: KEContext) -> Bool {
		/* Set strict */
		setStrictMode(context: ctxt)
		/* Compile "boot.js" */
		if let script = readResource(fileName: "boot", fileExtension: "js") {
			let _ = compile(context: ctxt, statement: script)
		}
		/* Define ExitCode enum */
		defineExitCode(context: ctxt)

		return true
	}

	private func setStrictMode(context ctxt: KEContext){
		if mConfig.doStrict {
			let _ = compile(context: ctxt, statement: "'use strict' ;")
		}
	}

	private func defineExitCode(context ctxt: KEContext){
		let enumtable = KEEnumTable(typeName: "ExitCode")
		enumtable.add(members: [
			KEEnumTable.Member(name: "noError",		value: CNExitCode.NoError.rawValue),
			KEEnumTable.Member(name: "internalError",	value: CNExitCode.InternalError.rawValue),
			KEEnumTable.Member(name: "commaneLineError",	value: CNExitCode.CommandLineError.rawValue),
			KEEnumTable.Member(name: "syntaxError",		value: CNExitCode.SyntaxError.rawValue),
			KEEnumTable.Member(name: "execError",		value: CNExitCode.ExecError.rawValue),
			KEEnumTable.Member(name: "exception",		value: CNExitCode.Exception.rawValue)
		])
		compile(context: ctxt, enumTable: enumtable)
	}

	public func readResource(fileName file: String, fileExtension ext: String) -> String? {
		if let url = CNFilePath.URLForResourceFile(fileName: file, fileExtension: ext, forClass: KECompiler.self) {
			let (scriptp, errorp) = url.loadContents()
			if let script = scriptp {
				return script as String
			} else if let error = errorp {
				log(string: "[Error] " + error.description)
			} else {
				log(string: "[Error] Unknown")
			}
		} else {
			log(string: "[Error] Can not read \"\(file).\(ext)\"")
		}
		return nil
	}

	public func log(string str: String) {
		if mConfig.doVerbose {
			mConsole.print(string: str)
		}
	}

	public func error(string str: String) {
		mConsole.print(string: str)
	}

	public func defineSetter(context ctxt: KEContext, instance inst:String, accessType access: CNAccessType, propertyName name:String){
		if access.isReadable {
			let stmt = "\(inst).__defineGetter__(\"\(name)\", function(   ){ return this.get(\"\(name)\"     ); }) ;\n"
			let _ = compile(context: ctxt, statement: stmt)
		}
		if access.isWritable {
			let stmt = "\(inst).__defineSetter__(\"\(name)\", function(val){ return this.set(\"\(name)\", val); }) ;\n"
			let _ = compile(context: ctxt, statement: stmt)
		}
	}

	public func compile(context ctxt: KEContext, statement stmt: String) -> JSValue? {
		log(string: stmt)
		return ctxt.evaluateScript(stmt)
	}

	public func compile(context ctxt: KEContext, statements stmts: Array<String>) -> JSValue? {
		var addedstmt: String = ""
		for stmt in stmts {
			log(string: stmt)
			addedstmt = addedstmt + stmt + "\n"
		}
		return ctxt.evaluateScript(addedstmt)
	}

	public func compile(context ctxt: KEContext, enumTable etable: KEEnumTable){
		/* Compile */
		let typename = etable.typeName
		log(string: "/* Define Enum: \(typename) */\n")

		var enumstmt = "let \(typename) = {\n"
		var is1st = true
		for member in etable.members {
			if !is1st {
				enumstmt += ",\n"
			}
			is1st = false
			enumstmt += "\t\(member.name) : \(member.value)"
		}
		enumstmt += "\n};\n"

		let _ = compile(context: ctxt, statement: enumstmt)
	}
}
