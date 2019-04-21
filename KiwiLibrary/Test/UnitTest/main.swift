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

	let filecons = CNFileConsole()
	let config   = KEConfig(kind: .Terminal, doStrict: true, doVerbose: true)

	let context  = KEContext(virtualMachine: JSVirtualMachine())
	context.exceptionCallback = {
		(_ exception: KEException) -> Void in
		filecons.error(string: exception.description)
	}

	let compiler = KLCompiler()
	if(compiler.compile(context: context, console: filecons, config: config)){
		filecons.print(string: "  -> Compiler: OK\n")
	} else {
		filecons.print(string: "  -> Compiler: NG\n")
	}

	/* Type */
	filecons.print(string: "/* Unit test for Type operation */\n")
	let result3 = UTType(context: context, console: filecons)

	/* Database */
	filecons.print(string: "/* Unit test for Database */\n")
	let result0 = UTDatabase(context: context, console: filecons)

	/* Operation*/
	filecons.print(string: "/* Unit test for Operation */\n")
	let result1 = UTOperation(context: context, console: filecons, config: config)

	/* Operation*/
	filecons.print(string: "/* Unit test for Operation2 */\n")
	let result2 = UTOperation2(console: filecons, config: config)

	if result0 && result1 && result2 && result3 {
		filecons.print(string: "Summary: OK\n")
	} else {
		filecons.print(string: "Summary: NG\n")
	}
}

main()


