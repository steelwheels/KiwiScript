/**
 * @file	KSConsole.swift
 * @brief	Define KSConsole library class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Canary
import JavaScriptCore
import Foundation

@objc public protocol KSConsoleProtocol: JSExport
{
	func print(_ value: JSValue) -> Void
	func error(_ value: JSValue) -> Void
	func scan() -> JSValue
}

@objc public class KSConsole: NSObject, KSConsoleProtocol
{
	private var mConsole: CNConsole
	private var mContext: JSContext
	
	public init(console cons: CNConsole, context ctxt: JSContext){
		mConsole = cons
		mContext = ctxt
	}

	public var console: CNConsole { get { return mConsole }}

	public func print(_ value: JSValue) -> Void {
		if let str = value.toString() {
			mConsole.print(string: str)
		} else {
			NSLog("Failed to convert string: \(value.description)")
		}
	}

	public func error(_ value: JSValue) -> Void {
		if let str = value.toString() {
			mConsole.error(string: str)
		} else {
			NSLog("Failed to convert string: \(value.description)")
		}
	}

	public func scan() -> JSValue {
		var result: JSValue
		if let str = mConsole.scan() {
			result = JSValue(object: str, in: mContext)
		} else {
			result = JSValue(undefinedIn: mContext)
		}
		return result
	}
}

public extension JSValue
{
	public var isConsole: Bool {
		return  (self.toObject() as? CNConsole) != nil
	}

	public func toConsole() -> CNConsole? {
		if let cons = self.toObject() as? CNConsole {
			return cons
		} else {
			return nil
		}
	}
}
