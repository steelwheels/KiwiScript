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
	func set(_ name: JSValue, _ value: JSValue)
	func get(_ name: JSValue) -> JSValue
}

@objc public class KLDictionary: NSObject, KLDictionaryProtocol
{
	private var mTable:	Dictionary<String, CNNativeValue>
	private var mContext:	KEContext

	public init(context ctxt: KEContext) {
		mTable		= [:]
		mContext	= ctxt
	}

	public func set(_ name: JSValue, _ value: JSValue) {
		if name.isString {
			mTable[name.toString()] = value.toNativeValue()
		} else {
			CNLog(logLevel: .error, message: "Invalid key to set data at \(#function)", atFunction: #function, inFile: #file)
		}
	}

	public func get(_ name: JSValue) -> JSValue {
		if name.isString {
			if let nval = mTable[name.toString()] {
				return nval.toJSValue(context: mContext)
			} else {
				return JSValue(nullIn: mContext)
			}
		} else {
			CNLog(logLevel: .error, message: "Invalid key to set data", atFunction: #function, inFile: #file)
			return JSValue(nullIn: mContext)
		}
	}
}

