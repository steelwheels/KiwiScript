/*
 * @file	UTCompiler.swift
 * @brief	Unit test for KECompiler class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

public func testCompiler(console cons: CNFileConsole) -> Bool
{
	let config   = KEConfig(kind: .Terminal, doStrict: true, logLevel: .detail)

	let context  = KEContext(virtualMachine: JSVirtualMachine())
	context.exceptionCallback = {
		(_ exception: KEException) -> Void in
		cons.error(string: exception.description)
	}

	console.print(string: "* Setup compiler\n")
	let compiler = KECompiler()

	let result: Bool
	console.print(string: "* compile\n")
	if compiler.compileBase(context: context, console: cons, config: config) {
		console.print(string: "Compile ... OK\n")
		result = true
	} else {
		console.print(string: "Compile ... NG\n")
		result = false
	}

	return result ;
}

