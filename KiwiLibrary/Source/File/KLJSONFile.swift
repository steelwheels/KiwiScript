/**
 * @file	KSJSONFile.swift
 * @brief	Define KSJSONFile class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

@objc public protocol KLJSONProtocol: JSExport
{
	func read(_ fname: JSValue) -> JSValue
	func write(_ fname: JSValue, _ json: JSValue) -> JSValue
}

@objc public class KLJSON: NSObject, KLJSONProtocol
{
	private var mContext: KEContext

	public init(context ctxt: KEContext){
		mContext = ctxt
	}

	public func read(_ fname: JSValue) -> JSValue {
		if let url = valueToURL(value: fname) {
			do {
				if let data = NSData(contentsOf: url) {
					let json = try JSONSerialization.jsonObject(with: data as Data, options: [])
					return JSValue(object: json, in: mContext)
				}
			}
			catch {
				/* through */
			}
		}
		return JSValue(nullIn: mContext)
	}

	public func write(_ fname: JSValue, _ json: JSValue) -> JSValue {
		var result = false
		if let url = valueToURL(value: fname) {
			do {
				if let jsdata = json.toObject() {
					let data = try JSONSerialization.data(withJSONObject: jsdata, options: JSONSerialization.WritingOptions.prettyPrinted)
					try data.write(to: url, options: .atomic)
					result = true
				}
			}
			catch {
				/* through */
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

