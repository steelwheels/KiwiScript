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
		ctxt.set(name: KHShell.EnvironmentItem, object: envval)
	}
}
