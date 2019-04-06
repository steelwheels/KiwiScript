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
	CNLogSetup(console: console, logLevel: .Flow)

	let config = KEConfig(kind: .Terminal, doStrict: true, doVerbose: true)

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
	
	/* Database */
	console.print(string: "/* Unit test for Database */\n")
	let result0 = UTDatabase(context: context, console: console)

	/* Operation*/
	console.print(string: "/* Unit test for Operation */\n")
	let result1 = UTOperation(context: context, console: console, config: config)

	/* Operation*/
	console.print(string: "/* Unit test for Operation2 */\n")
	let result2 = UTOperation2(console: console, config: config)

	if result0 && result1 && result2 {
		console.print(string: "Summary: OK\n")
	} else {
		console.print(string: "Summary: NG\n")
	}
}

main()


