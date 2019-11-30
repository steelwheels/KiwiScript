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
	let config   = KEConfig(kind: .Terminal, doStrict: true, logLevel: .detail)

	let context  = KEContext(virtualMachine: JSVirtualMachine())
	context.exceptionCallback = {
		(_ exception: KEException) -> Void in
		filecons.error(string: exception.description)
	}

	let compiler = KLCompiler()
	if(compiler.compileBase(context: context, console: filecons, config: config)){
		filecons.print(string: "  -> Compiler: OK\n")
	} else {
		filecons.print(string: "  -> Compiler: NG\n")
	}

	/* Type */
	filecons.print(string: "/* Unit test for Type operation */\n")
	let result3 = UTType(context: context, console: filecons)

	/* Math */
	filecons.print(string: "/* Unit test for Math operation */\n")
	let result4 = UTMath(context: context, console: filecons)

	/* Database */
	filecons.print(string: "/* Unit test for Database */\n")
	let result0 = UTDatabase(context: context, console: filecons)

	/* Operation*/
	filecons.print(string: "/* Unit test for Operation */\n")
	let result1 = UTOperation(context: context, console: filecons, config: config)

	/* Operation*/
	filecons.print(string: "/* Unit test for Operation2 */\n")
	let result2 = UTOperation2(console: filecons, config: config)

	/* NativeValue */
	filecons.print(string: "/* Unit test for native value */\n")
	let result5 = UTNativeValue(context: context, console: filecons)

	/* Thread */
	filecons.print(string: "/* Unit test for Thread */\n")
	let result6 = UTThread(context: context, console: filecons, config: config)

	/* Thread */
	filecons.print(string: "/* Unit test for Run */\n")
	let result7 = UTRun(context: context, console: filecons, config: config)

	if result0 && result1 && result2 && result3 && result4 && result5 && result6 && result7 {
		filecons.print(string: "Summary: OK\n")
	} else {
		filecons.print(string: "Summary: NG (\(result0) \(result1) \(result2) \(result3) \(result4) \(result5) \(result6))\n")
	}
}

main()


