/**
 * @file	KLStorage.swift
 * @brief	Extend CNStorage class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation

@objc public protocol KLStorageProtocol: JSExport
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

@objc public class KLStorage: NSObject, KLStorageProtocol
{
	private var mStorage:	CNStorage
	private var mContext:		KEContext

	public init(storage strg: CNStorage, context ctxt: KEContext){
		mStorage	= strg
		mContext	= ctxt
	}

	public func core() -> CNStorage {
		return mStorage
	}

	public func value(_ pathval: JSValue) -> JSValue {
		if pathval.isString {
			if let pathstr = pathval.toString() {
				switch CNValuePath.pathExpression(string: pathstr) {
				case .success(let path):
					if let retval = mStorage.value(forPath: path) {
						let conv = KLNativeValueToScriptValue(context: mContext)
						return conv.convert(value: retval)
					}
				case .failure(let err):
					CNLog(logLevel: .error, message: err.toString(), atFunction: #function, inFile: #file)
				}
			}
		}
		return JSValue(nullIn: mContext)
	}

	public func set(_ val: JSValue, _ pathval: JSValue) -> JSValue {
		let result: Bool
		if let path = valueToPath(pathval) {
			let conv = KLScriptValueToNativeValue()
			result = mStorage.set(value: conv.convert(scriptValue: val), forPath: path)
		} else {
			result = false
		}
		return JSValue(bool: result, in: mContext)
	}

	public func append(_ val: JSValue, _ pathval: JSValue) -> JSValue {
		let result: Bool
		if let path = valueToPath(pathval) {
			let conv = KLScriptValueToNativeValue()
			result = mStorage.append(value: conv.convert(scriptValue: val), forPath: path)
		} else {
			result = false
		}
		return JSValue(bool: result, in: mContext)
	}

	public func delete(_ pathval: JSValue) -> JSValue {
		let result: Bool
		if let path = valueToPath(pathval) {
			result = mStorage.delete(forPath: path)
		} else {
			result = false
		}
		return JSValue(bool: result, in: mContext)
	}

	private func valueToPath(_ val: JSValue) -> CNValuePath? {
		if val.isString {
			if let str = val.toString() {
				switch CNValuePath.pathExpression(string: str) {
				case .success(let path):
					return path
				case .failure(let err):
					CNLog(logLevel: .error, message: err.toString(), atFunction: #function, inFile: #file)
				}
			}
		}
		return nil
	}

	public func save() -> JSValue {
		let result = mStorage.save()
		return JSValue(bool: result, in: mContext)
	}

	public func toString() -> JSValue {
		let str = mStorage.toValue().toScript().toStrings().joined(separator: "\n")
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

