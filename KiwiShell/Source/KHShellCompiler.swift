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
	open func compileBaseAndLibrary(context ctxt: KEContext, resource res: KEResource, console cons: CNFileConsole, config conf: KEConfig) -> Bool {
		if super.compileBase(context: ctxt, console: cons, config: conf) {
			if super.compileLibraryInResource(context: ctxt, resource: res, console: cons, config: conf) {
				defineBuiltinFunctions(context: ctxt, console: cons)
				return true
			}
		}
		return false
	}

	private func defineBuiltinFunctions(context ctxt: KEContext, console cons: CNConsole) {
		#if os(OSX)
			defineSystemFunction(context: ctxt)
			//defineBuiltinFunction(context: ctxt, console: cons)
		#endif
	}

	/* Define "system" built-in command */
	#if os(OSX)
	private func defineSystemFunction(context ctxt: KEContext) {
		/* system */
		let systemfunc: @convention(block) (_ cmdval: JSValue, _ inval: JSValue, _ outval: JSValue, _ errval: JSValue) -> JSValue = {
			(_ cmdval: JSValue, _ inval: JSValue, _ outval: JSValue, _ errval: JSValue) -> JSValue in
			return KHShellCompiler.executeSystemCommand(commandValue: cmdval, inputValue: inval, outputValue: outval, errorValue: errval, context: ctxt)
		}
		ctxt.set(name: "system", function: systemfunc)
	}

	private static func executeSystemCommand(commandValue cmdval: JSValue, inputValue inval: JSValue, outputValue outval: JSValue, errorValue errval: JSValue, context ctxt: KEContext) -> JSValue {
		if let command = valueToString(value: cmdval),
		   let instrm  = valueToFileStream(value: inval),
		   let outstrm = valueToFileStream(value: outval),
		   let errstrm = valueToFileStream(value: errval) {
			let process = CNProcess(input: instrm, output: outstrm, error: errstrm, terminationHander: nil)
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

	/*
	private func defineBuiltinFunction(context ctxt: KEContext, console cons: CNConsole) {
		let builtinfunc: @convention(block) (_ paramval: JSValue, _ inval: JSValue, _ outval: JSValue, _ errval: JSValue) -> JSValue = {
			(_ paramval: JSValue, _ inval: JSValue, _ outval: JSValue, _ errval: JSValue) -> JSValue in
			if paramval.isArray {
				if let infile  = KHShellCompiler.vallueToFileStream(value: inval),
				   let outfile = KHShellCompiler.vallueToFileStream(value: outval),
				   let errfile = KHShellCompiler.vallueToFileStream(value: errval),
				   let arr     = paramval.toArray() {
					/* Make parameters */
					var params: Array<String> = []
					for elm in arr {
						if let str = elm as? String {
							params.append(str)
						} else {
							cons.error(string: "built-in: Invalid parameters\n")
						}
					}
					/* Execute function */
					let result  = KHBuiltinFunctions.shared.execute(parameters: params, input: infile, output: outfile, error: errfile)
					return JSValue(int32: result, in: ctxt)
				} else {
					cons.error(string: "built-in: Invalid parameters\n")
				}
			}
			return JSValue(nullIn: ctxt)
		}
		ctxt.set(name: KHBuiltinFunctions.functionName, function: builtinfunc)
	}
	*/

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
