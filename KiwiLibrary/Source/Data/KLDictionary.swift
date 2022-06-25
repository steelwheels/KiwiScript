/**
 * @file	KLDictionary.swift
 * @brief	Define KLDictionary object
 * @par Copyright
 *   Copyright (C) 2021-2022 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

@objc public protocol KLDictionaryProtocol: JSExport
{
	var count:  JSValue { get }	// Int
	var values: JSValue { get }	// Array(Value)
	var keys:   JSValue { get }	// Array(String)

	func set(_ value: JSValue, _ name: JSValue)	// (Value, string)
	func value(_ name: JSValue) -> JSValue		// (string) -> Value?
}

@objc public class KLDictionary: NSObject, KLDictionaryProtocol
{
	private var mDictionary:	CNDictionary
	private var mContext:		KEContext

	public init(dictionary dict: CNDictionary, context ctxt: KEContext) {
		mDictionary	= dict
		mContext	= ctxt
	}

	public var count: JSValue { get {
		return JSValue(int32: Int32(mDictionary.count), in: mContext)
	}}

	public var values: JSValue { get {
		var result: Array<Any> = []
		for val in mDictionary.values {
			result.append(val.toAny())
		}
		return JSValue(object: result, in: mContext)
	}}

	public var keys: JSValue { get {
		return JSValue(object: mDictionary.keys, in: mContext)
	}}

	public func set(_ value: JSValue, _ name: JSValue) {
		if let key = toKey(value: name) {
			let _ = mDictionary.set(value: value.toNativeValue(), forKey: key)
		}
	}

	public func value(_ name: JSValue) -> JSValue {
		if let key = toKey(value: name) {
			if let val = mDictionary.value(forKey: key) {
				return val.toJSValue(context: mContext)
			}
		}
		return JSValue(nullIn: mContext)
	}

	private func toKey(value val: JSValue) -> String? {
		if val.isString {
			return val.toString()
		} else {
			CNLog(logLevel: .error, message: "Invalid parameter type. the string is required for key to access dictionary.")
			return nil
		}
	}
}


