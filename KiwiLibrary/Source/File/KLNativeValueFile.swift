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
	func read(_ file: JSValue) -> JSValue
	func write(_ file: JSValue, _ json: JSValue) -> JSValue
}

@objc public class KLNativeValueFile: NSObject, KLNativeValueFileProtocol
{
	private var mContext: KEContext

	public init(context ctxt: KEContext){
		mContext = ctxt
	}

	public func read(_ file: JSValue) -> JSValue {
		if file.isObject {
			if let fileobj = file.toObject() as? KLFile {
				switch CNValueFile.read(file: fileobj.file) {
				case .ok(let value):
					return value.toJSValue(context: mContext)
				default:
					break
				}
			}
		}
		return JSValue(nullIn: mContext)
	}

	public func write(_ file: JSValue, _ json: JSValue) -> JSValue {
		var result = false
		if file.isObject {
			if let fileobj = file.toObject() as? KLFile {
				let nval = json.toNativeValue()
				let err  = CNValueFile.write(file: fileobj.file, nativeValue: nval)
				if err == nil {
					/* No error */
					result = true
				}
			}
		}
		return JSValue(bool: result, in: mContext)
	}
}

