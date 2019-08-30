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
			defineFunctions(context: ctxt, environment: env, console: cons, config: conf)
			return true
		} else {
			return false
		}
	}

	private func setEnvironment(context ctxt: KEContext, environment env: CNShellEnvironment) {
		let envval = KHShellEnvironment(environment: env, context: ctxt)
		ctxt.set(name: KHScriptThread.EnvironmentItem, object: envval)
	}

	private func defineFunctions(context ctxt: KEContext, environment env: CNShellEnvironment, console cons: CNConsole, config conf: KEConfig){
		/* Define "system" command */
		#if os(OSX)
		let systemFunc: @convention(block) (_ cmdval: JSValue, _ funcval: JSValue) -> JSValue = {
			(_ cmdval: JSValue, _ funcval: JSValue) -> JSValue in
			if cmdval.isString {
				if let cmdname = cmdval.toString() {
					/* Check callback function */
					let funcobj: JSValue?
					if funcval.isNull || funcval.isUndefined {
						funcobj = nil
					} else {
						funcobj = funcval
					}

					let intf    = CNShellInterface()
					let process = CNPipeProcess(interface: intf, environment: env, console: cons, config: conf, terminationHander: {
						(_ proc: Process) -> Void in
						if let funcobj = funcobj {
							let procobj = KLProcess(process: proc, context: ctxt)
							if let procval = JSValue(object: procobj, in: ctxt) {
								funcobj.call(withArguments: [procval])
							} else {
								NSLog("Failed to allocate process object")
							}
						}
					})
					process.execute(command: cmdname)
					let procobj = KLProcess(process: process.core, context: ctxt)
					return JSValue(object: procobj, in: ctxt)
				}
				return JSValue(nullIn: ctxt)
			}
			return JSValue(nullIn: ctxt)
		}
		ctxt.set(name: "system", function: systemFunc)
		#endif
	}
}
