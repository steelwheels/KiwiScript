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
	func print(_ value: JSValue)
	func error(_ value: JSValue)
	func dump(_ value: JSValue)
}

@objc public class KLConsole: NSObject, KLConsoleProtocol
{
	private var mContext: KEContext
	private var mConsole: CNFileConsole

	public init(context ctxt: KEContext, console cons: CNFileConsole){
		mContext = ctxt
		mConsole = cons
	}

	public var console: CNFileConsole {
		get { return mConsole }
	}

	public func log(_ value: JSValue){
		mConsole.log(string: value.toString() + "\n")
	}

	public func print(_ value: JSValue){
		mConsole.print(string: value.toString())
	}

	public func error(_ value: JSValue){
		mConsole.error(string: value.toString())
	}

	public func dump(_ value: JSValue){
		let native = value.toScript().toStrings().joined(separator: "\n")
		mConsole.print(string: native + "\n")
	}
}

