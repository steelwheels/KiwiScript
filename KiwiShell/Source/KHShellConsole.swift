/**
 * @file	KHShellConsole.swift
 * @brief	Define KHShellConsole class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiEngine
import KiwiLibrary
import CoconutData
import JavaScriptCore
import Foundation

public class KHShellConsole
{
	private var mContext:	KEContext
	private var mConsole:	CNConsole

	public init(context ctxt: KEContext, console cons: CNConsole){
		mContext	= ctxt
		mConsole	= cons
	}

	public func repl() -> Int32
	{
		let shell   = KHShell(context: mContext, console: mConsole)

		var docont = true
		var result: Int32 = 0
		while docont {
			if let str = mConsole.scan() {
				switch shell.execute(commandLine: str) {
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

