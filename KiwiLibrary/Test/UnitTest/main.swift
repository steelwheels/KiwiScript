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
	let filecons = CNFileConsole()
	let queue    = DispatchQueue(label: "UnitTest", qos: .default, attributes: .concurrent)
	let config   = KEConfig(applicationType: .terminal, doStrict: true, logLevel: .detail)

	let context  = KEContext(virtualMachine: JSVirtualMachine())
	context.exceptionCallback = {
		(_ exception: KEException) -> Void in
		filecons.error(string: exception.description)
	}

	let env = CNEnvironment()

	let fmanager = KLFileManager(context: context,
				     input:  filecons.inputHandle,
				     output: filecons.outputHandle,
				     error:  filecons.errorHandle)
	let compiler = KLCompiler()
	if(compiler.compileBase(context: context, environment: env, console: filecons, config: config)){
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
	let result6 = UTThread(context: context, queue: queue, console: filecons, config: config)

	/* Run */
	filecons.print(string: "/* Unit test for Run */\n")
	let result7 = UTRun(context: context, dispatchQueue: queue, console: filecons)

	/* FileManager */
	filecons.print(string: "/* Unit test for FileManager */\n")
	let result8 = UTFileManager(fileManager: fmanager, context: context, console: filecons)

	/* FontManager */
	filecons.print(string: "/* Unit test for FontManager */\n")
	let result10 = UTFontManager(context: context, console: filecons)

	/* ScriptManager */
	filecons.print(string: "/* Unit test for ScriptManager */\n")
	let result9 = UTScriptManager(console: filecons)

	/* Env */
	filecons.print(string: "/* Unit test for environmrnt */\n")
	let result11 = UTEnvironment(context: context, console: filecons)

	if result0 && result1 && result2 && result3 && result4 && result5 && result6 && result7 && result8 && result9 && result10 && result11 {
		filecons.print(string: "Summary: OK\n")
	} else {
		filecons.print(string: "Summary: NG (\(result0) \(result1) \(result2) \(result3) \(result4) \(result5) \(result6) \(result7) \(result8))\n")
	}
}

main()


