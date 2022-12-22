/**
 * @file	KLSet.swift
 * @brief	Define KLSet object
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

@objc public protocol KLSetProtocol: JSExport
{
	var count:  JSValue { get }	// Int
	var values: JSValue { get }	// Array(Value)

	func value(_ index: JSValue) -> JSValue		// Int -> Value?
	func contains(_ value: JSValue) -> JSValue	// (value) -> Bool

	func insert(_ value: JSValue)			// (Value)
}

@objc public class KLSet: NSObject, KLSetProtocol
{
	private var mSet:	CNSet
	private var mContext:	KEContext

	public init(set st: CNSet, context ctxt: KEContext) {
		mSet		= st
		mContext	= ctxt
	}

	public var count: JSValue { get {
		return JSValue(int32: Int32(mSet.count), in: mContext)
	}}

	public var values: JSValue { get {
		var result: Array<AnyObject> = []
		let conv = CNValueToAnyObject()
		for val in mSet.values {
			result.append(conv.convert(value: val))
		}
		return JSValue(object: result, in: mContext)
	}}

	public func value(_ index: JSValue) -> JSValue {
		if let idx = toInt(value: index) {
			if let val = mSet.value(at: idx) {
				let conv = KLNativeValueToScriptValue(context: mContext)
				return conv.convert(value: val)
			}
		}
		return JSValue(nullIn: mContext)
	}

	public func contains(_ value: JSValue) -> JSValue {
		let conv = KLScriptValueToNativeValue()
		let res  = mSet.contains(value: conv.convert(scriptValue: value))
		return JSValue(bool: res, in: mContext)
	}

	public func insert(_ value: JSValue) {
		let conv = KLScriptValueToNativeValue()
		let nval = conv.convert(scriptValue: value)
		let _    = mSet.insert(value: nval)
	}

	private func toInt(value val: JSValue) -> Int? {
		if val.isNumber {
			if let num = val.toNumber() {
				return num.intValue
			}
		} else {
			CNLog(logLevel: .error, message: "Invalid parameter type. the integer value is required for key to access set.")
		}
		return nil
	}
}

