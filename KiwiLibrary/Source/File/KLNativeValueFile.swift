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
				let text   = fileobj.file.getall()
				let parser = CNValueParser()
				switch parser.parse(source: text) {
				case .success(let val):
					let conv = KLNativeValueToScriptValue(context: mContext)
					return conv.convert(value: val)
				case .failure(let err):
					CNLog(logLevel: .error, message: "[Error] \(err.toString())", atFunction: #function, inFile: #file)
				}
			}
		}
		return JSValue(nullIn: mContext)
	}

	public func write(_ file: JSValue, _ json: JSValue) -> JSValue {
		var result = false
		if let fileobj = file.toObject() as? KLFile {
			let conv = KLScriptValueToNativeValue()
			let nval = conv.convert(scriptValue: json)
			let text = nval.toScript().toStrings().joined(separator: "\n")
			fileobj.file.put(string: text)
			result = true
		}
		return JSValue(bool: result, in: mContext)
	}
}

