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
	struct Result {
		public var name:	String
		public var result:	Bool
		public init(_ nm: String, _ res: Bool){
			name	= nm
			result	= res
		}
	}

	let filecons = CNFileConsole()
	let terminfo = CNTerminalInfo(width: 80, height: 25)
	let resource = KEResource(packageDirectory: Bundle.main.bundleURL)
	let env      = CNEnvironment()
	let config   = KEConfig(applicationType: .terminal, doStrict: true, logLevel: .warning)
	var results: Array<Result> = []

	let context  = KEContext(virtualMachine: JSVirtualMachine())
	context.exceptionCallback = {
		(_ exception: KEException) -> Void in
		filecons.error(string: exception.description)
	}

	let pmanager = CNProcessManager()

	let compiler = KLLibraryCompiler()
	guard compiler.compile(context: context, resource: resource, processManager: pmanager, terminalInfo: terminfo, environment: env, console: filecons, config: config) else {
		filecons.print(string: "  -> Compiler: NG\n")
		return
	}

	guard let fmanager = getFileManager(from: context) else {
		filecons.print(string: "[Error] No file manager => Terminated \n")
		return
	}

	/* Environment */
	filecons.print(string: "/* Unit test for Environment */\n")
	results.append(Result("Environment", UTEnvironment(context: context, console: filecons)))

	/* FileManager */
	filecons.print(string: "/* Unit test for FileManager */\n")
	results.append(Result("FileManager", UTFileManager(fileManager: fmanager, context: context, console: filecons)))

	/* FontManager */
	filecons.print(string: "/* Unit test for FontManager */\n")
	results.append(Result("FontManager", UTFontManager(context: context, console: filecons)))

	/* Math */
	filecons.print(string: "/* Unit test for math functions */\n")
	results.append(Result("Math", UTMath(context: context, console: filecons)))

	/* Native value */
	filecons.print(string: "/* Unit test for native value conversion */\n")
	results.append(Result("NativeValue", UTNativeValue(context: context, console: filecons)))

	/* Color */
	filecons.print(string: "/* Unit test for color manager */\n")
	results.append(Result("Color", UTColor(context: context, console: filecons)))

	/* Process */
	filecons.print(string: "/* Unit test for Process classes */\n")
	results.append(Result("Process", UTProcess(context: context, console: filecons)))

	/* Preference */
	filecons.print(string: "/* Unit test for Preference */\n")
	results.append(Result("Preference", UTPreference(context: context, console: filecons)))

	/* run function */
	filecons.print(string: "/* Unit test for run function */\n")
	results.append(Result("Run", UTRun(context: context, console: filecons)))

	/* ScriptManager */
	filecons.print(string: "/* Unit test for ScriptManager */\n")
	results.append(Result("ScriptManager", UTScriptManager(console: filecons)))

	/* Thread */
//	filecons.print(string: "/* Unit test for Thread */\n")
//	results.append(Result("Thread", UTThread(context: context, processManager: pmanager, console: filecons, config: config)))

	/* Command */
	filecons.print(string: "/* Unit test for Command */\n")
	results.append(Result("Command", UTCommand(context: context, console: filecons, environment: env)))

	/* Type */
	filecons.print(string: "/* Unit test for Type */\n")
	results.append(Result("Type", UTType(context: context, console: filecons)))

	/* URL */
	filecons.print(string: "/* Unit test for URL */\n")
	results.append(Result("URL", UTURL(fileManager: fmanager, context: context, console: filecons)))

	var summary = true
	for result in results {
		if result.result {
			filecons.print(string: "\(result.name) ... OK\n")
		} else {
			filecons.print(string: "\(result.name) ... Error\n")
			summary = false
		}
	}
	if summary {
		filecons.print(string: "SUMMARY: OK\n")
	} else {
		filecons.print(string: "SUMMARY: NG\n")
	}
}

private func getFileManager(from context: KEContext) -> KLFileManager? {
	if let value = context.get(name: "FileManager") {
		if value.isObject {
			return value.toObject() as? KLFileManager
		}
	}
	return nil
}

main()

