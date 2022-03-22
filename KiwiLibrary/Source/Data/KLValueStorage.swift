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

	func save() -> JSValue

	// For debugging
	func toString() -> JSValue
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
		if pathval.isString {
			if let pathstr = pathval.toString() {
				if let pathelms = CNValuePath.pathExpression(string: pathstr) {
					if let retval = mValueStorage.value(forPath: CNValuePath(elements: pathelms)) {
						return retval.toJSValue(context: mContext)
					}
				}
			}
		}
		return JSValue(nullIn: mContext)
	}

	public func set(_ val: JSValue, _ pathval: JSValue) -> JSValue {
		var result = false
		if pathval.isString {
			if let pathstr = pathval.toString() {
				let src    = val.toNativeValue()
				if let pathelms = CNValuePath.pathExpression(string: pathstr) {
					result = mValueStorage.set(value: src, forPath: CNValuePath(elements: pathelms))
				}
			}
		}
		return JSValue(bool: result, in: mContext)
	}

	public func save() -> JSValue {
		let result = mValueStorage.save()
		return JSValue(bool: result, in: mContext)
	}

	public func toString() -> JSValue {
		let str = mValueStorage.toValue().toText().toStrings().joined(separator: "\n")
		return JSValue(object: str, in: mContext)
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

