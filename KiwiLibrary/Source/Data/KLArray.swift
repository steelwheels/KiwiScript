/**
 * @file	KLArray.swift
 * @brief	Define KLArray class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

@objc public protocol KLArrayProtocol: JSExport
{
	var count:  JSValue { get }	// Int
	var values: JSValue { get }	// Array<Value>

	func value(_ index: JSValue) -> JSValue			// Int -> Value?
	func set(_ value: JSValue, _ index: JSValue)		// (Value, Int)
	func append(_ value: JSValue)				// (Value)
}

@objc public class KLArray: NSObject, KLArrayProtocol
{
	private var mArray:	CNArray
	private var mContext:	KEContext

	public init(array arr: CNArray, context ctxt: KEContext) {
		mArray		= arr
		mContext	= ctxt
	}

	public var count: JSValue { get {
		return JSValue(int32: Int32(mArray.count), in: mContext)
	}}

	public var values: JSValue { get {
		var result: Array<Any> = []
		for val in mArray.values {
			result.append(val.toAny())
		}
		return JSValue(object: result, in: mContext)
	}}

	public func value(_ index: JSValue) -> JSValue	{
		if let idx = toInt(value: index) {
			if let val = mArray.value(at: idx) {
				return val.toJSValue(context: mContext)
			}
		}
		return JSValue(nullIn: mContext)
	}

	public func set(_ value: JSValue, _ index: JSValue) {
		if let idx = toInt(value: index) {
			let nval = value.toNativeValue()
			let _    = mArray.set(value: nval, at: idx)
		}
	}

	public func append(_ value: JSValue) {
		let nval = value.toNativeValue()
		let _    = mArray.append(value: nval)
	}

	private func toInt(value val: JSValue) -> Int? {
		if val.isNumber {
			if let num = val.toNumber() {
				return num.intValue
			}
		} else {
			CNLog(logLevel: .error, message: "Invalid parameter type. the integer value is required for key to access array.")
		}
		return nil
	}
}

