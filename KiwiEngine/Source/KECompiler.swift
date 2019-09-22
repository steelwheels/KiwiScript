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
	public init(){

	}
	
	open func compile(context ctxt: KEContext, console cons: CNConsole, config conf: KEConfig) -> Bool {
		/* Set strict */
		setStrictMode(context: ctxt, console: cons, config: conf)
		/* Define Enum Types */
		defineEnumTypes(context: ctxt, console: cons, config: conf)
		return true
	}

	private func setStrictMode(context ctxt: KEContext, console cons: CNConsole, config conf: KEConfig){
		if conf.doStrict {
			let _ = compile(context: ctxt, statement: "'use strict' ;\n", console: cons, config: conf)
		}
	}

	private func defineEnumTypes(context ctxt: KEContext, console cons: CNConsole, config conf: KEConfig){
		let table = KEEnumTable.shared
		for typename in table.typeNames.sorted() {
			if let etype = table.search(by: typename) {
				compile(context: ctxt, enumType: etype, console: cons, config: conf)
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

	public func readResource(fileName file: String, fileExtension ext: String, forClass fclass: AnyClass) -> String? {
		do {
			if let url = CNFilePath.URLForResourceFile(fileName: file, fileExtension: ext, forClass: fclass) {
				return try String(contentsOf: url, encoding: .utf8)
			} else {
				return nil
			}
		} catch _ {
			return nil
		}
	}

	public func readFromURL(URL url: URL, console cons: CNConsole) -> String? {
		if let str = url.loadContents() {
			return str as String
		} else {
			cons.error(string: "Failed to load")
			return nil
		}
	}

	public func defineSetter(context ctxt: KEContext, instance inst:String, accessType access: CNAccessType, propertyName name:String, console cons: CNConsole, config conf: KEConfig){
		if access.isReadable {
			let stmt = "\(inst).__defineGetter__(\"\(name)\", function(   ){ return this.get(\"\(name)\"     ); }) ;\n"
			let _ = compile(context: ctxt, statement: stmt, console: cons, config: conf)
		}
		if access.isWritable {
			let stmt = "\(inst).__defineSetter__(\"\(name)\", function(val){ return this.set(\"\(name)\", val); }) ;\n"
			let _ = compile(context: ctxt, statement: stmt, console: cons, config: conf)
		}
	}

	public func compile(context ctxt: KEContext, instance inst: String, object obj: KEObject, console cons: CNConsole, config conf: KEConfig) {
		/* Define setter and getter */
		for pname in obj.propertyNames {
			defineSetter(context: ctxt, instance: inst, accessType: .ReadWriteAccess, propertyName: pname, console: cons, config: conf)
		}
	}

	public func compile(context ctxt: KEContext, statement stmt: String, console cons: CNConsole, config conf: KEConfig) -> JSValue? {
		if conf.doVerbose {
			cons.print(string: stmt)
		}
		return ctxt.evaluateScript(stmt)
	}

	public func compile(context ctxt: KEContext, statements stmts: Array<String>, console cons: CNConsole, config conf: KEConfig) -> JSValue? {
		let script = stmts.joined(separator: "\n")
		if conf.doVerbose {
			cons.print(string: script)
		}
		return ctxt.evaluateScript(script)
	}

	public func compile(context ctxt: KEContext, enumType etype: KEEnumType, console cons: CNConsole, config conf: KEConfig){
		/* Compile */
		let typename = etype.typeName
		if conf.doVerbose {
			cons.print(string: "/* Define Enum: \(typename) */\n")
		}

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

		let _ = compile(context: ctxt, statement: enumstmt, console: cons, config: conf)
	}

	public func compile(context ctxt: KEContext, destination dst: String, dictionary dict: Dictionary<String, String>, console cons: CNConsole, config conf: KEConfig){
		var stmt  = "\(dst) = {\n"
		var is1st = true
		for (key, value) in dict {
			if is1st {
				is1st = false
			} else {
				stmt = ",\n"
			}
			stmt += "\t\(key): \(value)"
		}
		stmt += "\n};\n"
		let _ = compile(context: ctxt, statement: stmt, console: cons, config: conf)
	}

	public func compile(context ctxt: KEContext, sourceFiles srcfiles: Array<URL>, console cons: CNConsole, config conf: KEConfig) -> Bool {
		var result = true
		for srcfile in srcfiles {
			if let scr = srcfile.loadContents() {
				let _ = compile(context: ctxt, statement: scr as String, console: cons, config: conf)
			} else {
				cons.error(string: "Failed to load file: \(srcfile.absoluteString)")
				result = false
			}
		}
		return result
	}

	private func message(fromError err: NSError?) -> String {
		if let e = err {
			return e.toString()
		} else {
			return "Unknown error"
		}
	}
}

