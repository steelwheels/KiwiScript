/**
 * @file	KLEnvironment.swift
 * @brief	Define KLEnvironment class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation

@objc public protocol KLEnvironmentProtocol: JSExport
{
	func set(_ name: JSValue, _ value: JSValue)
	func get(_ name: JSValue) -> JSValue
}

@objc public class KLEnvironment: NSObject, KLEnvironmentProtocol
{
	private var mEnvironment: CNEnvironment
	private var mContext:	  KEContext

	public init(environment env: CNEnvironment, context ctxt: KEContext){
		mEnvironment	= env
		mContext	= ctxt
	}

	public func set(_ name: JSValue, _ value: JSValue) {
		mEnvironment.set(name: name.toString(), string: valueToString(value: value))
	}

	public func get(_ name: JSValue) -> JSValue {
		if let res = mEnvironment.get(name: name.toString()) {
			return JSValue(object: res, in: mContext)
		} else {
			return JSValue(nullIn: mContext)
		}
	}

	private func valueToString(value val: JSValue) -> String {
		let result: String
		if val.isURL {
			result = val.toURL().path
		} else {
			result = val.toString()
		}
		return result
	}
}
