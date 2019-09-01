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
	open func compile(context ctxt: KEContext, environment env: CNShellEnvironment, console cons: CNConsole, config conf: KEConfig) -> Bool {
		if super.compile(context: ctxt, console: cons, config: conf) {
			setEnvironment(context: ctxt, environment: env)
			return true
		} else {
			return false
		}
	}

	private func setEnvironment(context ctxt: KEContext, environment env: CNShellEnvironment) {
		let envval = KHShellEnvironment(environment: env, context: ctxt)
		ctxt.set(name: KHScriptThread.EnvironmentItem, object: envval)
	}

	open func defineBuiltinFunctions(parentThread parent: CNPipeThread, context ctxt: KEContext) {
		#if os(OSX)
			defineSystemFunction(parentThread: parent, context: ctxt)
		#endif
	}

	/* Define "system" built-in command */
	#if os(OSX)
	private func defineSystemFunction(parentThread parent: CNPipeThread, context ctxt: KEContext) {
		/* system */
		let systemfunc: @convention(block) (_ cmdval: JSValue, _ cbval: JSValue) -> JSValue = {
			(_ cmdval: JSValue, _ cbval: JSValue) -> JSValue in
			return KHShellCompiler.executeSystemCommand(parentThread: parent, context: ctxt, commandValue: cmdval, functionValue: cbval)
		}
		ctxt.set(name: "system", function: systemfunc)
	}
	#endif

	#if os(OSX)
	private static func executeSystemCommand(parentThread parent: CNPipeThread, context ctxt: KEContext, commandValue cmdval: JSValue, functionValue cbval: JSValue) -> JSValue {
		if let command = valueToString(value: cmdval) {
			let callback = valueToFunction(value: cbval)
			let cbfunc = { (_ proc: Process) -> Void in
				if let cbfunc = callback {
					let procobj = KLProcess(process: proc, context: ctxt)
					if let procval = JSValue(object: procobj, in: ctxt) {
						cbfunc.call(withArguments: [procval])
					}
				}
			}
			let process = CNPipeProcess(interface:   parent.interface,
						    environment: parent.environment,
						    console:     parent.console,
						    config:      parent.config,
						    terminationHander: cbfunc)
			process.execute(command: command)
			let procval = KLProcess(process: process.core, context: ctxt)
			return JSValue(object: procval, in: ctxt)
		}
		return JSValue(nullIn: ctxt)
	}
	#endif

	#if os(OSX)
	private static func valueToString(value val: JSValue) -> String? {
		if val.isString {
			if let str = val.toString() {
				return str
			}
		}
		return nil
	}
	#endif

	#if os(OSX)
	private static func valueToFunction(value val: JSValue) -> JSValue? {
		if !(val.isNull || val.isUndefined) {
			return val
		} else {
			return nil
		}
	}
	#endif
}
