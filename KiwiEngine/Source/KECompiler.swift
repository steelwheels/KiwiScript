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

	public func compile(context ctxt: KEContext) -> Bool {
		/* Compile "boot.js" */
		if let script = readResource(fileName: "boot", fileExtension: "js") {
			let _ = compile(context: ctxt, statement: script)
		}
		return true
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
}
