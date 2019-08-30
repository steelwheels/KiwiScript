/**
 * @file	KHShell.swift
 * @brief	Define KHShell class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutShell
import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation

@objc public protocol KHShellThreadProtocol: KHThreadProtocol
{
}

@objc public class KHShellThread: CNShellThread, KHShellThreadProtocol
{
	private var mContext:		KEContext

	public init(virtualMachine vm: JSVirtualMachine, shellInterface intf: CNShellInterface, environment env: CNShellEnvironment, console cons: CNConsole, config conf: KEConfig){
		mContext	= KEContext(virtualMachine: vm)
		super.init(interface: intf, environment: env, console: cons, config: conf)

		/* Compile the context */
		let compiler = KHShellCompiler()
		guard compiler.compile(context: mContext, environment: env, console: cons, config: conf) else {
			cons.error(string: "Failed to compile script thread context\n")
			return
		}
	}

	public override func promptString() -> String {
		return "jsh$ "
	}
}


