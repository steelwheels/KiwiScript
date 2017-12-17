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
	func print(_ value: JSValue)
	func error(_ value: JSValue)
	func log(_ value: JSValue)
}

@objc public class KLConsole: NSObject, KLConsoleProtocol
{
	private var mConsole: CNConsole
	
	public init(console cons: CNConsole){
		mConsole = cons
	}

	public func print(_ value: JSValue){
		mConsole.print(string: value.toString())
	}

	public func error(_ value: JSValue){
		mConsole.error(string: value.toString())
	}

	public func log(_ value: JSValue){
		mConsole.print(string: value.toString())
	}
}


