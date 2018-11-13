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
		/* Define Enum Types */
		defineEnumTypes(context: ctxt)
		/* Compile "boot.js" */
		if let script = readResource(fileName: "boot", fileExtension: "js") {
			let _ = compile(context: ctxt, statement: script)
		}
		return true
	}

	private func setStrictMode(context ctxt: KEContext){
		if mConfig.doStrict {
			let _ = compile(context: ctxt, statement: "'use strict' ;\n")
		}
	}

	private func defineEnumTypes(context ctxt: KEContext){
		let table = KEEnumTable.shared
		for typename in table.typeNames.sorted() {
			if let etype = table.search(by: typename) {
				compile(context: ctxt, enumType: etype)
			}
		}
	}

	public func readUserScript(scriptFile file: String) -> String? {
		do {
			let url  = URL(fileURLWithPath: file)
			return try String(contentsOf: url, encoding: .utf8)
		} catch _ {
			return nil
		}
	}

	public func readResource(fileName file: String, fileExtension ext: String) -> String? {
		do {
			if let url = CNFilePath.URLForResourceFile(fileName: file, fileExtension: ext, forClass: KECompiler.self) {
				return try String(contentsOf: url, encoding: .utf8)
			} else {
				return nil
			}
		} catch _ {
			return nil
		}
	}

	public func readFromURL(URL url: URL) -> String? {
		let (scriptp, errorp) = url.loadContents()
		if let script = scriptp {
			return script as String
		} else if let error = errorp {
			log(string: "[Error] " + error.description)
		} else {
			log(string: "[Error] Unknown")
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

	public func compile(context ctxt: KEContext, instance inst: String, object obj: KEObject) {
		/* Define setter and getter */
		for pname in obj.propertyNames {
			defineSetter(context: ctxt, instance: inst, accessType: .ReadWriteAccess, propertyName: pname)
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

	public func compile(context ctxt: KEContext, enumType etype: KEEnumType){
		/* Compile */
		let typename = etype.typeName
		log(string: "/* Define Enum: \(typename) */\n")

		var enumstmt = "let \(typename) = {\n"
		var is1st = true
		for member in etype.members {
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

