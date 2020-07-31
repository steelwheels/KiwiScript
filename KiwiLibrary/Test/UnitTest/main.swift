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
	let pmanager = CNProcessManager()
	let config   = KEConfig(applicationType: .terminal, doStrict: true, logLevel: .detail)

	let context  = KEContext(virtualMachine: JSVirtualMachine())
	context.exceptionCallback = {
		(_ exception: KEException) -> Void in
		filecons.error(string: exception.description)
	}

	let terminfo = CNTerminalInfo(width: 80, height: 25)
	let env      = CNEnvironment()

	let compiler = KLCompiler()
	if(compiler.compileBase(context: context, terminalInfo: terminfo, environment: env, console: filecons, config: config)){
		filecons.print(string: "  -> Compiler: OK\n")
	} else {
		filecons.print(string: "  -> Compiler: NG\n")
	}

	/* Get file manager */
	guard let fmanager = getFileManager(from: context) else {
		filecons.print(string: "[Error] No file manager => Terminated \n")
		return
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
	let result6 = UTThread(context: context, processManager: pmanager, console: filecons, config: config)

	/* Run */
	filecons.print(string: "/* Unit test for Run */\n")
	let result7 = UTRun(context: context, console: filecons)

	/* Application */
	filecons.print(string: "/* Unit test for Application */\n")
	let result14 = UTApplication(context: context, console: filecons)

	/* FileManager */
	filecons.print(string: "/* Unit test for FileManager */\n")
	let result8 = UTFileManager(fileManager: fmanager, context: context, console: filecons)

	/* URL */
	filecons.print(string: "/* Unit test for URL */\n")
	let result12 = UTURL(fileManager: fmanager, context: context, console: filecons)

	/* FontManager */
	filecons.print(string: "/* Unit test for FontManager */\n")
	let result10 = UTFontManager(context: context, console: filecons)

	/* ScriptManager */
	filecons.print(string: "/* Unit test for ScriptManager */\n")
	let result9 = UTScriptManager(console: filecons)

	/* Environment */
	filecons.print(string: "/* Unit test for environmrnt */\n")
	let result11 = UTEnvironment(context: context, console: filecons)

	/* Preference */
	filecons.print(string: "/* Unit test for preference */\n")
	let result13 = UTPreference(context: context, console: filecons)

	if result0 && result1 && result2 && result3 && result4 && result5 && result6 && result7 && result8 && result9 && result10 && result11 && result12 && result13 && result14 {
		filecons.print(string: "Summary: OK\n")
	} else {
		filecons.print(string: "Summary: NG (\(result0) \(result1) \(result2) \(result3) \(result4) \(result5) \(result6) \(result7) \(result8))\n")
	}
}

private func getFileManager(from context: KEContext) -> KLFileManager? {
	if let value = context.getValue(name: "FileManager") {
		if value.isObject {
			return value.toObject() as? KLFileManager
		}
	}
	return nil
}

main()


