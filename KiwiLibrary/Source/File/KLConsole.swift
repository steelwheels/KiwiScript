/**
 * @file	KLConsole.swift
 * @brief	Extend KLConsole class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation

@objc public protocol KLConsoleProtocol: JSExport
{
	func log(_ value: JSValue)
	func debug(_ value: JSValue)
	func print(_ value: JSValue)
	func error(_ value: JSValue)
}

@objc public class KLConsole: NSObject, KLConsoleProtocol
{
	private var mContext: KEContext
	private var mConsole: CNConsole

	public init(context ctxt: KEContext, console cons: CNConsole){
		mContext = ctxt
		mConsole = cons
	}

	public var console: CNConsole {
		get { return mConsole }
	}

	public func log(_ value: JSValue){
		mConsole.print(string: value.toString())
	}

	public func debug(_ value: JSValue){
		let pref = CNPreference.shared.systemPreference
		if pref.doVerbose {
			log(value)
		}
	}

	public func print(_ value: JSValue){
		mConsole.print(string: value.toString())
	}

	public func error(_ value: JSValue){
		mConsole.error(string: value.toString())
	}
}

