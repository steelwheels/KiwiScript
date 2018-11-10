/**
 * @file	UTListener.swift
 * @brief	Unit test for KiwiEngine framework
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

public func testListener(console cons: CNConsole, config conf: KEConfig) -> Bool
{
	var result = true

	let context  = KEContext(virtualMachine: JSVirtualMachine())
	context.exceptionCallback = {
		(_ exception: KEException) -> Void in
		cons.error(string: exception.description + "\n")
	}

	console.print(string: "* Setup compiler\n")
	let compiler = KECompiler(console: cons, config: conf)
	if compiler.compile(context: context) {
		cons.print(string: "Compile: OK\n")

		cons.print(string: "/* Allocate OperationObject */\n")
		let obj = KEOperationObject(context: context)
		context.set(name: "Operation", object: obj)
		compiler.compile(context: context, instance: "Operation", object: obj)

		let flagstmt = "var flag = false ;\n"
		let _ = compiler.compile(context: context, statement: flagstmt)

		let liststmt =  "Operation.addListener(\"isCanceled\", function(value){ flag = true ;}) ; \n"
				//"\tconsole.log(\"isCanceled is changed:\" + value + \"\\n\") ; \n" +
				//"}) ;\n"
		let _ = compiler.compile(context: context, statement: liststmt)

		let assignstmt = "Operation.isCanceled = true ;\n"
		let _ = compiler.compile(context: context, statement: assignstmt)

		result = false
		if let flagval = context.objectForKeyedSubscript("flag") {
			cons.print(string: "flag: \(flagval)\n")
			if flagval.isBoolean {
				if flagval.toBool() {
					result = true
				}
			}
		} else {
			cons.print(string: "flag: undefined\n")
		}
		if result {
			cons.print(string: "Exec: OK\n")
		} else {
			cons.print(string: "Exec: NG\n")
		}
		return result
	} else {
		cons.print(string: "Compile: NG\n")
		result = false
	}
	return result
}

