/**
 * @file	KLDictionary.swift
 * @brief	Define KLDictionary object
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

@objc public protocol KLDictionaryProtocol: JSExport
{
	func setNumber(_ name: JSValue, _ value: JSValue)
	func setString(_ name: JSValue, _ value: JSValue)

	func number(_ name: JSValue) -> JSValue
	func string(_ name: JSValue) -> JSValue
}

@objc public class KLDictionary: NSObject, KLDictionaryProtocol
{
	private var mTable:	Dictionary<String, CNValue>
	private var mContext:	KEContext

	public init(context ctxt: KEContext) {
		mTable		= [:]
		mContext	= ctxt
	}

	public init(value val: Dictionary<String, CNValue>, context ctxt: KEContext) {
		mTable		= val
		mContext	= ctxt
	}

	public func setNumber(_ name: JSValue, _ value: JSValue) {
		if name.isString && value.isNumber {
			mTable[name.toString()]  = .numberValue(value.toNumber())
		} else {
			CNLog(logLevel: .error, message: "Invalid name:\(name) or value:\(value)", atFunction: #function, inFile: #file)
		}
	}

	public func setString(_ name: JSValue, _ value: JSValue) {
		if name.isString && value.isString {
			mTable[name.toString()]  = .stringValue(value.toString())
		} else {
			CNLog(logLevel: .error, message: "Invalid name:\(name) or value:\(value)", atFunction: #function, inFile: #file)
		}
	}

	public func string(_ name: JSValue) -> JSValue {
		if name.isString {
			if let nval = mTable[name.toString()] {
				switch nval {
				case .stringValue(let str):
					return JSValue(object: str, in: mContext)
				default:
					break
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
				switch nval {
				case .numberValue(let num):
					return JSValue(object: num, in: mContext)
				default:
					break
				}
			}
		} else {
			CNLog(logLevel: .error, message: "Invalid key to set data", atFunction: #function, inFile: #file)
		}
		return JSValue(nullIn: mContext)
	}
}

