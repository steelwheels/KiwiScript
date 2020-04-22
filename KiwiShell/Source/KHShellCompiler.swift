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

open class KHShellCompiler: KLCompiler
{
	open func compileBaseAndLibrary(context ctxt: KEContext, processManager procmgr: CNProcessManager, queue disque: DispatchQueue, environment env: CNEnvironment, resource res: KEResource, console cons: CNFileConsole, config conf: KEConfig) -> Bool {
		if super.compileBase(context: ctxt, environment: env, console: cons, config: conf) {
			if super.compileLibraryInResource(context: ctxt, processManager: procmgr, queue: disque, environment: env, resource: res, console: cons, config: conf) {
				defineBuiltinFunctions(context: ctxt, processManager: procmgr, environment: env, console: cons)
				return true
			}
		}
		return false
	}

	private func defineBuiltinFunctions(context ctxt: KEContext, processManager procmgr: CNProcessManager, environment env: CNEnvironment, console cons: CNConsole) {
		#if os(OSX)
			defineSystemFunction(context: ctxt, processManager: procmgr, environment: env)
		#endif
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
