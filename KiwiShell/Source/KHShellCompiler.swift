/**
 * @file	KHShellCompiler.swift
 * @brief	Define KHShellCompiler class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import KiwiLibrary
import KiwiEngine
import CoconutData
import CoconutShell
import JavaScriptCore
import Foundation

public class KHShellCompiler: KECompiler
{
	open func compile(context ctxt: KEContext, readline readln: CNReadline, resource res: KEResource, processManager procmgr: CNProcessManager, terminalInfo terminfo: CNTerminalInfo, console cons: CNConsole, environment env: CNEnvironment, config conf: KEConfig) -> Bool {
		defineGlobalVariables(context: ctxt, readline: readln, console: cons)
		defineEnvironmentVariables(environment: env)
		defineBuiltinFunctions(context: ctxt, console: cons, processManager: procmgr, environment: env)
		importBuiltinLibrary(context: ctxt, console: cons, config: conf)
		return true
	}

	private func defineGlobalVariables(context ctxt: KEContext, readline readln: CNReadline, console cons: CNConsole){
		let pref = KHPreference(context: ctxt)
		ctxt.set(name: "Preference", object: pref)

		let readobj = KLReadline(readline: readln, console: cons, context: ctxt)
		ctxt.set(name: "Readline", object: readobj)
	}

	private func defineEnvironmentVariables(environment env: CNEnvironment) {
		let verstr = CNPreference.shared.systemPreference.version
		env.set(name: "JSH_VERSION", value: .stringValue(verstr))
	}

	private func defineBuiltinFunctions(context ctxt: KEContext, console cons: CNConsole, processManager procmgr: CNProcessManager, environment env: CNEnvironment) {
		defineCdFunction(context: ctxt, console: cons, environment: env)
		defineHistoryFunction(context: ctxt, console: cons, environment: env)
		defineSetupFunction(context: ctxt, console: cons, environment: env)
		#if os(OSX)
			defineSystemFunction(context: ctxt, processManager: procmgr, environment: env)
		#endif
	}

	private func defineCdFunction(context ctxt: KEContext, console cons: CNConsole, environment env: CNEnvironment) {
		/* cd command */
		let cdfunc: @convention(block) () -> JSValue = {
			() -> JSValue in
			let cdcmd = KLCdCommand(context: ctxt, console: cons, environment: env)
			return JSValue(object: cdcmd, in: ctxt)
		}
		ctxt.set(name: "cdcmd", function: cdfunc)
	}

	private func defineHistoryFunction(context ctxt: KEContext, console cons: CNConsole, environment env: CNEnvironment) {
		/* history command */
		let histfunc: @convention(block) () -> JSValue = {
			() -> JSValue in
			let cdcmd = KHHistoryCommand(context: ctxt, console: cons, environment: env)
			return JSValue(object: cdcmd, in: ctxt)
		}
		ctxt.set(name: KHHistoryCommandStatement.commandName, function: histfunc)
	}

	private func defineSetupFunction(context ctxt: KEContext, console cons: CNConsole, environment env: CNEnvironment) {
		/* setup command */
		let setupfunc: @convention(block) () -> JSValue = {
			() -> JSValue in
			let cdcmd = KLInstallCommand(context: ctxt, console: cons, environment: env)
			return JSValue(object: cdcmd, in: ctxt)
		}
		ctxt.set(name: KLInstallCommand.builtinFunctionName, function: setupfunc)
	}

	private func importBuiltinLibrary(context ctxt: KEContext, console cons: CNConsole, config conf: KEConfig) {
		let libnames = ["Terminal"]
		do {
			for libname in libnames {
				if let url = CNFilePath.URLForResourceFile(fileName: libname, fileExtension: "js", subdirectory: "Library", forClass: KHShellCompiler.self) {
					let script = try String(contentsOf: url, encoding: .utf8)
					let _ = compile(context: ctxt, statement: script, console: cons, config: conf)
				} else {
					cons.error(string: "Built-in script \"\(libname)\" is not found.")
				}
			}
		} catch {
			cons.error(string: "Failed to read built-in script in KiwiLibrary")
		}
	}

	/* Define "system" built-in command */
	#if os(OSX)
	private func defineSystemFunction(context ctxt: KEContext, processManager procmgr: CNProcessManager, environment env: CNEnvironment) {
		/* system */
		let systemfunc: @convention(block) (_ cmdval: JSValue, _ inval: JSValue, _ outval: JSValue, _ errval: JSValue) -> JSValue = {
			(_ cmdval: JSValue, _ inval: JSValue, _ outval: JSValue, _ errval: JSValue) -> JSValue in
			return KHShellCompiler.executeSystemCommand(processManager: procmgr, commandValue: cmdval, inputValue: inval, outputValue: outval, errorValue: errval, context: ctxt, environment: env)
		}
		ctxt.set(name: "system", function: systemfunc)
	}

	private static func executeSystemCommand(processManager procmgr: CNProcessManager, commandValue cmdval: JSValue, inputValue inval: JSValue, outputValue outval: JSValue, errorValue errval: JSValue, context ctxt: KEContext, environment env: CNEnvironment) -> JSValue {
		if let command = valueToString(value: cmdval),
		   let instrm  = valueToFileStream(value: inval),
		   let outstrm = valueToFileStream(value: outval),
		   let errstrm = valueToFileStream(value: errval) {
			let process = CNProcess(processManager: procmgr, input: instrm, output: outstrm, error: errstrm, environment: env, terminationHander: nil)
			let _       = procmgr.addProcess(process: process)
			process.execute(command: command)
			let procval = KLProcess(process: process, context: ctxt)
			return JSValue(object: procval, in: ctxt)
		}
		return JSValue(nullIn: ctxt)
	}

	private static func valueToString(value val: JSValue) -> String? {
		if val.isString {
			if let str = val.toString() {
				return str
			}
		}
		return nil
	}

	private static func valueToFileStream(value val: JSValue) -> CNFileStream? {
		if val.isObject {
			if let file = val.toObject() as? KLFile {
				return .fileHandle(file.fileHandle)
			} else if let pipe = val.toObject() as? KLPipe {
				return .pipe(pipe.pipe)
			}
		}
		return nil
	}

	private static func valueToFunction(value val: JSValue) -> JSValue? {
		if !(val.isNull || val.isUndefined) {
			return val
		} else {
			return nil
		}
	}
	#endif

	private class func vallueToFileStream(value val: JSValue) -> CNFileStream? {
		if let obj = val.toObject() {
			if let file = obj as? KLFile {
				return .fileHandle(file.fileHandle)
			} else if let pipe = obj as? KLPipe {
				return .pipe(pipe.pipe)
			}
		}
		return nil
	}
}
