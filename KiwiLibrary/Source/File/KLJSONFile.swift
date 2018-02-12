/**
 * @file	KSJSONFile.swift
 * @brief	Define KSJSONFile class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import KiwiEngine
import Canary
import JavaScriptCore
import Foundation

@objc public protocol KLJSONProtocol: JSExport
{
	func read(_ fname: JSValue) -> JSValue
	func write(_ fname: JSValue, _ json: JSValue) -> JSValue

	func serialize(_ json: JSValue) -> JSValue
}

@objc public class KLJSON: NSObject, KLJSONProtocol
{
	private var mContext: KEContext

	public init(context ctxt: KEContext){
		mContext = ctxt
	}

	public func read(_ fname: JSValue) -> JSValue {
		if let url = valueToURL(value: fname) {
			let (obj, err) = CNJSONFile.readFile(URL: url)
			if let e = err {
				NSLog(e.toString())
			} else {
				return JSValue(object: obj, in: mContext)
			}
		}
		return JSValue(nullIn: mContext)
	}

	public func write(_ fname: JSValue, _ json: JSValue) -> JSValue {
		let errcode:Int32
		if let url = valueToURL(value: fname) {
			if let obj = json.toObject() as? NSDictionary {
				if let err = CNJSONFile.writeFile(URL: url, dictionary: obj) {
					let errstr = err.toString()
					NSLog("Can not write JSON file: \(errstr)")
					errcode = 3
				} else {
					/* No errors */
					errcode = 0
				}
			} else {
				let jsonstr = String(describing: json.toString())
				NSLog("Invalid json data: \(jsonstr)")
				errcode = 2
			}
		} else {
			errcode = 1	/* Invalid file name */
		}
		return JSValue(int32: errcode, in: mContext)
	}

	public func serialize(_ json: JSValue) -> JSValue {
		if let obj = json.toObject() as? NSDictionary {
			let (str, err) = CNJSONFile.serialize(dictionary: obj)
			if let e = err {
				let estr = e.toString()
				NSLog("serialization failed: \(estr)")
			} else {
				return JSValue(object: str!, in: mContext)
			}
		}
		return JSValue(nullIn: mContext)
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

