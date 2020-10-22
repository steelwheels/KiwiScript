/*
 * @file	main.swift
 * @brief	main function for unit test
 * @par Copyright
 *   Copyright (C) 2018-2020 Steel Wheels Project
 */

import CoconutData
import KiwiLibrary
import KiwiEngine
import JavaScriptCore
import Foundation

public func main()
{
	let filecons = CNFileConsole()
	let terminfo = CNTerminalInfo(width: 80, height: 25)
	let resource = KEResource(baseURL: Bundle.main.bundleURL)
	let env      = CNEnvironment()
	let config   = KEConfig(applicationType: .terminal, doStrict: true, logLevel: .warning)
	
	let context  = KEContext(virtualMachine: JSVirtualMachine())
	context.exceptionCallback = {
		(_ exception: KEException) -> Void in
		filecons.error(string: exception.description)
	}

	let pmanager = CNProcessManager()

	let compiler = KLCompiler()
	if(compiler.compileBase(context: context, terminalInfo: terminfo, environment: env, console: filecons, config: config)){
		filecons.print(string: "  -> Compiler: OK\n")
	} else {
		filecons.print(string: "  -> Compiler: NG\n")
	}
	if compiler.compileLibrary(context: context, resource: resource, processManager: pmanager, environment: env, console: filecons, config: config) {
		filecons.print(string: "  -> Compile Library: OK\n")
	} else {
		filecons.print(string: "  -> Compile Library: NG\n")
	}

	guard let fmanager = getFileManager(from: context) else {
		filecons.print(string: "[Error] No file manager => Terminated \n")
		return
	}

	/* Application */
	filecons.print(string: "/* Unit test for Application */\n")
	let result0 = UTApplication(context: context, console: filecons)

	/* Database */
	filecons.print(string: "/* Unit test for Database */\n")
	let result14 = UTDatabase(context: context, console: filecons)

	/* Environment */
	filecons.print(string: "/* Unit test for Environment */\n")
	let result1 = UTEnvironment(context: context, console: filecons)

	/* FileManager */
	filecons.print(string: "/* Unit test for FileManager */\n")
	let result2 = UTFileManager(fileManager: fmanager, context: context, console: filecons)

	/* FontManager */
	filecons.print(string: "/* Unit test for FontManager */\n")
	let result3 = UTFontManager(context: context, console: filecons)

	/* Math */
	filecons.print(string: "/* Unit test for math functions */\n")
	let result4 = UTMath(context: context, console: filecons)

	/* Native value */
	filecons.print(string: "/* Unit test for native value conversion */\n")
	let result5 = UTNativeValue(context: context, console: filecons)

	/* Operation */
	filecons.print(string: "/* Unit test for native Operation */\n")
	let result6 = UTOperation1(context: context, console: filecons, config: config)
	let result7 = UTOperation2(console: filecons, config: config)

	/* Preference */
	filecons.print(string: "/* Unit test for Preference */\n")
	let result8 = UTPreference(context: context, console: filecons)

	/* run function */
	filecons.print(string: "/* Unit test for run function */\n")
	let result9 = UTRun(context: context, console: filecons)

	/* ScriptManager */
	filecons.print(string: "/* Unit test for ScriptManager */\n")
	let result10 = UTScriptManager(console: filecons)

	/* suspend function */
	filecons.print(string: "/* Unit test for suspend/resume func */\n")
	let result15 = UTSuspend(context: context, console: filecons)

	/* Thread */
	filecons.print(string: "/* Unit test for Thread */\n")
	let result11 = UTThread(context: context, processManager: pmanager, console: filecons, config: config)

	/* Type */
	filecons.print(string: "/* Unit test for Type */\n")
	let result12 = UTType(context: context, console: filecons)

	/* URL */
	filecons.print(string: "/* Unit test for URL */\n")
	let result13 = UTURL(fileManager: fmanager, context: context, console: filecons)

	let summary = result0 && result1 && result2 && result3 && result4 && result5
			&& result6 && result7 && result8 && result9 && result10 && result11
			&& result12 && result13 && result14 && result15
	if summary {
		filecons.print(string: "SUMMARY: OK\n")
	} else {
		filecons.print(string: "SUMMARY: NG\n")
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

