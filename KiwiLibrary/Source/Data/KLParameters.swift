/**
 * @file	KLParameters.swift
 * @brief	Define KLParameters object
 * @par Copyright
 *   Copyright (C) 2021-2022 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

@objc public protocol KLParametersProtocol: JSExport
{
	var object: JSValue { get }

	func setNumber(_ name: JSValue, _ value: JSValue)
	func setString(_ name: JSValue, _ value: JSValue)

	func number(_ name: JSValue) -> JSValue
	func string(_ name: JSValue) -> JSValue
}

@objc public class KLParameters: NSObject, KLParametersProtocol
{
	private var mTable:	Dictionary<String, NSObject>
	private var mContext:	KEContext

	public init(context ctxt: KEContext) {
		mTable		= [:]
		mContext	= ctxt
	}

	public init(value val: Dictionary<String, Any>, context ctxt: KEContext) {
		mTable		= KLParameters.makeDictionary(source: val)
		mContext	= ctxt
	}

	public var object: JSValue {
		get { return JSValue(object: mTable, in: mContext) }
	}

	private static func makeDictionary(source src: Dictionary<String, Any>) -> Dictionary<String, NSObject> {
		var result: Dictionary<String, NSObject> = [:]
		for key in src.keys {
			if let val = src[key] {
				if let str = val as? NSString {
					result[key] = str
				} else if let num = val as? NSNumber {
					result[key] = num
				} else if let obj = val as? NSObject {
					CNLog(logLevel: .error, message: "Unknown object: \(val)", atFunction: #function, inFile: #file)
					result[key] = obj
				} else {
					CNLog(logLevel: .error, message: "Unknown any value: \(val)", atFunction: #function, inFile: #file)
				}
			}
		}
		return result
	}

	public func setNumber(_ name: JSValue, _ value: JSValue) {
		if name.isString && value.isNumber {
			mTable[name.toString()]  = value.toNumber()
		} else {
			CNLog(logLevel: .error, message: "Invalid name:\(name) or value:\(value)", atFunction: #function, inFile: #file)
		}
	}

	public func setString(_ name: JSValue, _ value: JSValue) {
		if name.isString && value.isString {
			if let str = value.toString() {
				mTable[name.toString()] = str as NSString
			} else {
				CNLog(logLevel: .error, message: "Can not happen", atFunction: #function, inFile: #file)
			}
		} else {
			CNLog(logLevel: .error, message: "Invalid name:\(name) or value:\(value)", atFunction: #function, inFile: #file)
		}
	}

	public func string(_ name: JSValue) -> JSValue {
		if name.isString {
			if let nval = mTable[name.toString()] {
				if let str = nval as? NSString {
					return JSValue(object: str, in: mContext)
				}
			}
		} else {
			CNLog(logLevel: .error, message: "Invalid key to set data", atFunction: #function, inFile: #file)
		}
		return JSValue(nullIn: mContext)
	}

	public func number(_ name: JSValue) -> JSValue {
		if name.isString {
			if let nval = mTable[name.toString()] {
				if let num = nval as? NSNumber {
					return JSValue(object: num, in: mContext)
				}
			}
		} else {
			CNLog(logLevel: .error, message: "Invalid key to set data", atFunction: #function, inFile: #file)
		}
		return JSValue(nullIn: mContext)
	}
}

