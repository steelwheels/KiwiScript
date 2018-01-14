/**
 * @file	KLConsole.swift
 * @brief	Extend KLConsole class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Canary
import KiwiEngine
import JavaScriptCore
import Foundation

@objc public protocol KLConsoleProtocol: JSExport
{
	func log(_ value: JSValue)
	func setCursesMode(_ mode: JSValue)
}

@objc public class KLConsole: NSObject, KLConsoleProtocol
{
	private var mConsole: CNCursesConsole
	
	public init(console cons: CNCursesConsole){
		mConsole = cons
	}

	public func log(_ value: JSValue){
		mConsole.print(string: value.toString())
	}

	public func setCursesMode(_ mode: JSValue){
		if mode.isBoolean {
			let m : CNCursesConsole.ConsoleMode
			if mode.toBool() {
				m = .Curses
			} else {
				m = .Shell
			}
			mConsole.setMode(mode: m)
		}
	}
}


