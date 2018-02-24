/**
 * @file	KHShellConsole.swift
 * @brief	Define KHShellConsole class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import Foundation
import JavaScriptCore
import Canary

public class KHShellConsole
{
	private var mApplicationName:	String
	private var mConsole:		CNFileConsole
	private var mShell: 		KHShell

	public init(applicationName aname: String, console cons: CNFileConsole){
		mApplicationName	= aname
		mConsole		= cons
		if let vm = JSVirtualMachine() {
			mShell			= KHShell(virtualMachine: vm, console: cons)
		} else {
			fatalError("Failed to allocate VM")
		}
	}

	public func repl() {
		let editline = CNEditLine()
		editline.setup(programName: mApplicationName, console: mConsole)
		editline.doBuffering = true

		var docont = true
		while docont {
			if let str = editline.gets() {
				switch mShell.execute(commandLine: str) {
				case .Continue:
					break
				case .Exit(_):
					docont = false
				}
			}
		}
	}
}

