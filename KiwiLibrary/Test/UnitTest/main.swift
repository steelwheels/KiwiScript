/*
 * @file	main.swift
 * @brief	main function for unit test
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiLibrary
import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

public func main()
{
	Swift.print("[UnitTest]\n")

	let console = CNFileConsole()

	let config = KLConfig(kind: .Terminal, doStrict: true, doVerbose: false)

	let context  = KEContext(virtualMachine: JSVirtualMachine())
	context.exceptionCallback = {
		(_ exception: KEException) -> Void in
		console.error(string: exception.description)
	}

	let compiler = KLCompiler(console: console, config: config)
	if(compiler.compile(context: context)){
		console.print(string: "  -> Compiler: OK\n")
	} else {
		console.print(string: "  -> Compiler: NG\n")
	}

	console.print(string: "[Bye]\n")
}

main()


