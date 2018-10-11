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
				let except = KEException.Runtime("\(#function) " + e.toString())
				mContext.exceptionCallback(except)
			} else {
				return objectToValue(JSONObject: obj!, context: mContext)
			}
		}
		return JSValue(nullIn: mContext)
	}

	public func write(_ fname: JSValue, _ json: JSValue) -> JSValue {
		let errcode:Int32
		if let url = valueToURL(value: fname) {
			if let obj = valueToObject(value: json) {
				if let err = CNJSONFile.writeFile(URL: url, JSONObject: obj) {
					let errstr = err.toString()
					let except = KEException.Runtime("\(#function) Can not write JSON file: \(errstr)")
					mContext.exceptionCallback(except)
					errcode = 3
				} else {
					/* No errors */
					errcode = 0
				}
			} else {
				let jsonstr = String(describing: json.toString())
				let except = KEException.Runtime("\(#function) Invalid json data: \(jsonstr)")
				mContext.exceptionCallback(except)
				errcode = 2
			}
		} else {
			errcode = 1	/* Invalid file name */
		}
		return JSValue(int32: errcode, in: mContext)
	}

	public func serialize(_ json: JSValue) -> JSValue {
		if let obj = valueToObject(value: json) {
			let (str, err) = CNJSONFile.serialize(JSONObject: obj)
			if let e = err {
				let estr = e.toString()
				let except = KEException.Runtime("\(#function) serialization failed: \(estr)")
				mContext.exceptionCallback(except)
			} else {
				return JSValue(object: str!, in: mContext)
			}
		}
		return JSValue(nullIn: mContext)
	}

	private func valueToObject(value val: JSValue) -> CNJSONObject? {
		let valobj = val.toObject()
		if let dictobj = valobj as? NSDictionary {
			return CNJSONObject(dictionary: dictobj)
		} else if let arrobj = valobj as? NSArray {
			return CNJSONObject(array: arrobj)
		} else {
			return nil
		}
	}

	private func objectToValue(JSONObject obj: CNJSONObject, context ctxt: KEContext) -> JSValue {
		let result: JSValue
		switch obj {
		case .Array(let array):		result = JSValue(object: array, in: ctxt)
		case .Dictionary(let dict):	result = JSValue(object: dict, in: ctxt)
		}
		return result
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

