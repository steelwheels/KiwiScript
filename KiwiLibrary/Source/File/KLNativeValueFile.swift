/**
 * @file	KSNativeValueFile.swift
 * @brief	Define KSNativeValueFile class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

@objc public protocol KLNativeValueFileProtocol: JSExport
{
	func read(_ fname: JSValue) -> JSValue
	func write(_ fname: JSValue, _ json: JSValue) -> JSValue
}

@objc public class KLNativeValueFile: NSObject, KLNativeValueFileProtocol
{
	private var mContext: KEContext

	public init(context ctxt: KEContext){
		mContext = ctxt
	}

	public func read(_ fname: JSValue) -> JSValue {
		if let url = valueToURL(value: fname) {
			switch CNNativeValueFile.readFile(URL: url) {
			case .ok(let value):
				return value.toJSValue(context: mContext)
			default:
				break
			}
		}
		return JSValue(nullIn: mContext)
	}

	public func write(_ fname: JSValue, _ json: JSValue) -> JSValue {
		var result = false
		if let url = valueToURL(value: fname) {
			let nval = json.toNativeValue()
			let err  = CNNativeValueFile.writeFile(URL: url, nativeValue: nval)
			if err == nil {
				/* No error */
				result = true
			}
		}
		return JSValue(bool: result, in: mContext)
	}

	private func valueToURL(value v: JSValue) -> URL? {
		if v.isString {
			return URL(fileURLWithPath: v.toString())
		} else if v.isObject {
			if let url = v.toObject() as? URL {
				return url
			}
		}
		return nil
	}
}

