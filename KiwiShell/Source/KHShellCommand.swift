/**
 * @file	KHShellCommand.swift
 * @brief	Define KHShellCommand class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import KiwiLibrary
import KiwiEngine
import CoconutShell
import CoconutData
import JavaScriptCore
import Foundation

public class KHHistoryCommand: KLCommand
{
	public init(context ctxt: KEContext, console cons: CNConsole, environment env: CNEnvironment) {
		super.init(function: {
			(_ arg: JSValue, _ ctxt: KEContext, _ env: CNEnvironment) -> Int32 in
			return KHHistoryCommand.execute(arg, ctxt, cons, env)
		}, context: ctxt, console: cons, environment: env)
	}

	private static func execute(_ arg: JSValue, _ ctxt: KEContext, _ console: CNConsole, _ env: CNEnvironment) -> Int32 {
		let script =   "do {\n"
			     + "  let hists = Readline.history() ;\n"
			     + "  for(hist of hists){\n"
			     + "    console.log(hist) ;\n"
			     + "  }\n"
			     + "} while(false) ;\n"
		if let _ = ctxt.evaluateScript(script) {
			return 0
		} else {
			return -1
		}
	}
}
