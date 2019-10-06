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
	open func compileShell(context ctxt: KEContext, environment env: CNShellEnvironment, resource res: KEResource, console cons: CNConsole, config conf: KEConfig) -> Bool {
		if super.compileBase(context: ctxt, console: cons, config: conf) {
			if super.compileResource(context: ctxt, resource: res, console: cons, config: conf) {
				setEnvironment(context: ctxt, environment: env)
				defineBuiltinFunctions(context: ctxt)
				return true
			}
		}
		return false
	}

	private func setEnvironment(context ctxt: KEContext, environment env: CNShellEnvironment) {
		let envval = KHShellEnvironment(environment: env, context: ctxt)
		ctxt.set(name: KHScriptThread.EnvironmentItem, object: envval)
	}

	private func defineBuiltinFunctions(context ctxt: KEContext) {
		#if os(OSX)
			defineSystemFunction(context: ctxt)
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
		   let infile  = valueToFile(value: inval),
		   let outfile = valueToFile(value: outval),
		   let errfile = valueToFile(value: errval) {
			let inhdl   = infile.fileHandle
			let outhdl  = outfile.fileHandle
			let errhdl  = errfile.fileHandle
			let process = CNProcess(input: inhdl, output: outhdl, error:  errhdl, terminationHander: nil)
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

	private static func valueToFile(value val: JSValue) -> KLFile? {
		if val.isObject {
			if let file = val.toObject() as? KLFile {
				return file
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
}
