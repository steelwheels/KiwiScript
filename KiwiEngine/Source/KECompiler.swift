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
	
	open func compileBase(context ctxt: KEContext, console cons: CNFileConsole, config conf: KEConfig) -> Bool {
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
		let etable = KEEnumTable.shared
		for typename in etable.typeNames.sorted() {
			if let etype = etable.search(by: typename) {
				compile(context: ctxt, enumType: etype, console: cons, config: conf)
			}
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

	public func defineSetters(context ctxt: KEContext, instance inst: String, object obj: KEObject, console cons: CNConsole, config conf: KEConfig) {
		/* Define setter and getter */
		for pname in obj.propertyNames {
			defineSetter(context: ctxt, instance: inst, accessType: .ReadWriteAccess, propertyName: pname, console: cons, config: conf)
		}
	}


	/* Call this afer "CompileBase" method is called */
	open func compileLibraryInResource(context ctxt: KEContext, resource res: KEResource, console cons: CNConsole, config conf: KEConfig) -> Bool {
		var result = true
		/* Compile library */
		if let libnum = res.countOfLibraries() {
			for i in 0..<libnum {
				if let scr = res.loadLibrary(index: i) {
					let _ = self.compile(context: ctxt, statement: scr, console: cons, config: conf)
				} else {
					if let fname = res.URLOfLibrary(index: i) {
						cons.error(string: "Failed to load library: \(fname.absoluteString)")
						result = false
					} else {
						cons.error(string: "Failed to load file in library section")
						result = false
					}
				}
			}
		}
		return result && (ctxt.errorCount == 0)
	}

	public func compileScriptInResource(context ctxt: KEContext, resource res: KEResource, scriptName name: String, console cons: CNConsole, config conf: KEConfig) -> Bool {
		var result = true
		/* Compile script */
		if let scrnum = res.countOfScripts(identifier: name) {
			for i in 0..<scrnum {
				if let scr = res.loadScript(identifier: name, index: i) {
					let _ = self.compile(context: ctxt, statement: scr, console: cons, config: conf)
				} else {
					if let fname = res.URLOfScript(identifier: name, index: i) {
						cons.error(string: "Failed to load script : \(fname.absoluteString)")
					} else {
						cons.error(string: "Failed to load file in script section")
					}
					result = false
				}
			}
		}
		return result && (ctxt.errorCount == 0)
	}

	public func compile(context ctxt: KEContext, statement stmt: String, console cons: CNConsole, config conf: KEConfig) -> JSValue? {
		switch conf.logLevel {
		case .error, .warning, .flow:
			break
		case .detail:
			cons.print(string: stmt)
		}
		return ctxt.evaluateScript(stmt)
	}

	public func compile(context ctxt: KEContext, statements stmts: Array<String>, console cons: CNConsole, config conf: KEConfig) -> JSValue? {
		let script = stmts.joined(separator: "\n")
		switch conf.logLevel {
		case .error, .warning, .flow:
			break
		case .detail:
			cons.print(string: script)
		}
		return ctxt.evaluateScript(script)
	}

	public func compile(context ctxt: KEContext, enumType etype: KEEnumType, console cons: CNConsole, config conf: KEConfig){
		/* Compile */
		let typename = etype.typeName
		switch conf.logLevel {
		case .error, .warning, .flow:
			break
		case .detail:
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
	
	private func message(fromError err: NSError?) -> String {
		if let e = err {
			return e.toString()
		} else {
			return "Unknown error"
		}
	}
}

