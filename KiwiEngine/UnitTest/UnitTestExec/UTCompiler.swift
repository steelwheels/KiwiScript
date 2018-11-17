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

public func testCompiler(console cons: CNConsole) -> Bool
{
	let config   = KEConfig(doStrict: true, doVerbose: true)

	let context  = KEContext(virtualMachine: JSVirtualMachine())
	context.exceptionCallback = {
		(_ exception: KEException) -> Void in
		cons.error(string: exception.description)
	}

	console.print(string: "* Setup compiler\n")
	let compiler = KECompiler(console: cons, config: config)

	let result: Bool
	console.print(string: "* compile\n")
	if compiler.compile(context: context) {
		console.print(string: "Compile ... OK\n")
		result = true
	} else {
		console.print(string: "Compile ... NG\n")
		result = false
	}

	return result ;
}

