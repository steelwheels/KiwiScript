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
	let config   = KEConfig(applicationType: .terminal, doStrict: true, logLevel: .detail)

	let context  = KEContext(virtualMachine: JSVirtualMachine())
	context.exceptionCallback = {
		(_ exception: KEException) -> Void in
		cons.error(string: exception.description)
	}

	console.print(string: "* Setup compiler\n")
	let compiler = KECompiler()

	let terminfo    = CNTerminalInfo(width: 80, height: 25)
	let environment = CNEnvironment()

	let result: Bool
	console.print(string: "* compile\n")
	if compiler.compileBase(context: context, terminalInfo: terminfo, environment: environment, console: cons, config: config) {
		console.print(string: "Compile ... OK\n")
		result = true
	} else {
		console.print(string: "Compile ... NG\n")
		result = false
	}

	return result ;
}

