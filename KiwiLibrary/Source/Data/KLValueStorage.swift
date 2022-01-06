/**
 * @file	KLValueStorage.swift
 * @brief	Extend CNValueStorage class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation

@objc public protocol KLValueStorageProtocol: JSExport
{
	// value(path: [string]): value
	func value(_ path: JSValue) -> JSValue

	// set(value: any, path: [string]): boolean
	func set(_ value: JSValue, _ path: JSValue) -> JSValue

	func store() -> JSValue
}

@objc public class KLValueStorage: NSObject, KLValueStorageProtocol
{
	private var mValueStorage:	CNValueStorage
	private var mContext:		KEContext

	public init(valueStorage stoage: CNValueStorage, context ctxt: KEContext){
		mValueStorage	= stoage
		mContext	= ctxt
	}

	public func core() -> CNValueStorage {
		return mValueStorage
	}

	public func value(_ pathval: JSValue) -> JSValue {
		if let path = valueToArray(value: pathval) {
			if let retval = mValueStorage.value(forPath: path) {
				return retval.toJSValue(context: mContext)
			}
		}
		return JSValue(nullIn: mContext)
	}

	public func set(_ val: JSValue, _ pathval: JSValue) -> JSValue {
		var result = false
		let src    = val.toNativeValue()
		if let path = valueToArray(value: pathval) {
			result = mValueStorage.set(value: src, forPath: path)
		}
		return JSValue(bool: result, in: mContext)
	}

	public func store() -> JSValue {
		let result = mValueStorage.store()
		return JSValue(bool: result, in: mContext)
	}

	private func valueToArray(value val: JSValue) -> Array<String>? {
		if let arr = val.toArray() {
			var result: Array<String> = []
			for elm in arr {
				if let str = elm as? String {
					result.append(str)
				} else {
					CNLog(logLevel: .error, message: "The parameter must be [string]", atFunction: #function, inFile: #file)
					return nil
				}
			}
			return result
		}
		return nil
	}
}

