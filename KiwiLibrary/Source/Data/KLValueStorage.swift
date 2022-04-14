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

	// append(value: any, path: string): boolean
	func append(_ val: JSValue, _ path: JSValue) -> JSValue

	// delete(value: any, path: string): boolean
	func delete(_ path: JSValue) -> JSValue

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
				if let (ident, pathelms) = CNValuePath.pathExpression(string: pathstr) {
					if let retval = mValueStorage.value(forPath: CNValuePath(identifier: ident, elements: pathelms)) {
						return retval.toJSValue(context: mContext)
					}
				}
			}
		}
		return JSValue(nullIn: mContext)
	}

	public func set(_ val: JSValue, _ pathval: JSValue) -> JSValue {
		let result: Bool
		if let path = valueToPath(pathval) {
			result = mValueStorage.set(value: val.toNativeValue(), forPath: path)
		} else {
			result = false
		}
		return JSValue(bool: result, in: mContext)
	}

	public func append(_ val: JSValue, _ pathval: JSValue) -> JSValue {
		let result: Bool
		if let path = valueToPath(pathval) {
			result = mValueStorage.append(value: val.toNativeValue(), forPath: path)
		} else {
			result = false
		}
		return JSValue(bool: result, in: mContext)
	}

	public func delete(_ pathval: JSValue) -> JSValue {
		let result: Bool
		if let path = valueToPath(pathval) {
			result = mValueStorage.delete(forPath: path)
		} else {
			result = false
		}
		return JSValue(bool: result, in: mContext)
	}

	private func valueToPath(_ val: JSValue) -> CNValuePath? {
		if val.isString {
			if let str = val.toString() {
				if let (ident, elms) = CNValuePath.pathExpression(string: str) {
					return CNValuePath(identifier: ident, elements: elms)
				}
			}
		}
		return nil
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

