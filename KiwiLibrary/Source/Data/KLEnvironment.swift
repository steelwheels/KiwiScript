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

	var currentDirectory:  JSValue { get }
	var temporaryDirectory: JSValue { get }
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
		mEnvironment.set(name: name.toString(), value: value.toNativeValue())
	}

	public func get(_ name: JSValue) -> JSValue {
		if let val = mEnvironment.get(name: name.toString()) {
			return val.toJSValue(context: mContext)
		} else {
			return JSValue(nullIn: mContext)
		}
	}

	private func valueToString(value val: JSValue) -> String {
		let result: String
		if let url = val.toURL() {
			result = url.path
		} else {
			result = val.toString()
		}
		return result
	}

	public var currentDirectory:  JSValue {
		get {
			let dir = mEnvironment.currentDirectory
			let url = KLURL(URL: dir, context: mContext)
			return JSValue(object: url, in: mContext)
		}
	}

	public var temporaryDirectory: JSValue {
		get {
			let dir = mEnvironment.temporaryDirectory
			let url = KLURL(URL: dir, context: mContext)
			return JSValue(object: url, in: mContext)
		}
	}
}
