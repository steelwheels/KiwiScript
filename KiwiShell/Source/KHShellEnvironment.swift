/**
 * @file	KHShellEnvironemnt.swift
 * @brief	Define KHShellEnvironment class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiLibrary
import KiwiEngine
import CoconutShell
import JavaScriptCore
import Foundation

public protocol KHShellEnvironmentProtocol: JSExport
{
	func set(_ name: JSValue, _ value: JSValue)
	func get(_ name: JSValue) -> JSValue
}

@objc public class KHShellEnvironment: NSObject, KHShellEnvironmentProtocol
{
	private var mEnvironment:	CNShellEnvironment
	private var mContext:		KEContext

	public init(environment env: CNShellEnvironment, context ctxt: KEContext){
		mEnvironment	= env
		mContext	= ctxt
	}

	public func set(_ name: JSValue, _ value: JSValue) {
		if let name = valueToName(value: name) {
			let natval = value.toNativeValue()
			mEnvironment.set(name: name, value: natval)
		}
		NSLog("Failed to set value")
	}

	public func get(_ name: JSValue) -> JSValue {
		if let name = valueToName(value: name) {
			if let val = mEnvironment.get(name: name) {
				return val.toJSValue(context: mContext)
			}
		}
		return JSValue(nullIn: mContext)
	}

	private func valueToName(value val: JSValue) -> String? {
		if val.isString {
			return val.toString()
		} else {
			return nil
		}
	}

}

