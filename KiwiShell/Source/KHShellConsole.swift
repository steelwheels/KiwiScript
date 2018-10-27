/**
 * @file	KHShellConsole.swift
 * @brief	Define KHShellConsole class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiEngine
import KiwiObject
import CoconutData
import JavaScriptCore
import Foundation

public class KHShellConsole
{
	private var mApplication:	KMApplication

	public init(application app: KMApplication){
		mApplication	= app
	}

	public func repl() -> Int32
	{
		let shell   = KHShell(application: mApplication)
		let console = mApplication.console

		var docont = true
		var result: Int32 = 0
		while docont {
			if let str = console.scan() {
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

