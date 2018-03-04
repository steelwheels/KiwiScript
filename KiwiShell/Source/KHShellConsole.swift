/**
 * @file	KHShellConsole.swift
 * @brief	Define KHShellConsole class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import Foundation
import KiwiEngine
import JavaScriptCore
import Canary

public class KHShellConsole
{
	private var mApplicationName:	String
	private var mConsole:		CNFileConsole
	private var mShell: 		KHShell

	public init(applicationName aname: String, context ctxt: KEContext, console cons: CNFileConsole){
		mApplicationName	= aname
		mConsole		= cons
		mShell			= KHShell(context: ctxt, console: cons)
	}

	public func repl() -> Int32
	{
		let editline = CNEditLine()
		editline.setup(programName: mApplicationName, console: mConsole)
		editline.doBuffering = true

		var docont = true
		var result: Int32 = 0
		while docont {
			if let str = editline.gets() {
				switch mShell.execute(commandLine: str) {
				case .Continue:
					break
				case .Exit(let code):
					result = code
					docont = false
				}
			}
		}
		return result
	}
}
