/**
 * @file	KLNativeValue.swift
 * @brief	Extend CNValue class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import CoconutDatabase
import JavaScriptCore
import Foundation

public class KLNativeValueToScriptValue
{
	private var mContext: KEContext

	public init(context ctxt: KEContext){
		mContext = ctxt
	}

	public func convert(value val: CNValue) -> JSValue {
		let result: JSValue
		switch val {
		case .boolValue(let val):
			result = JSValue(bool: val, in: mContext)
		case .numberValue(let val):
			result = JSValue(object: val, in: mContext)
		case .stringValue(let val):
			result = JSValue(object: val, in: mContext)
		case .enumValue(let val):
			result = convert(enumValue: val)
		case .arrayValue(let val):
			result = convert(arrayValue: val)
		case .setValue(let val):
			result = convert(setValue: val)
		case .dictionaryValue(let val):
			result = convert(dictionaryValue: val)
		case .interfaceValue(let val):
			result = val.toJSValue(context: mContext)
		case .objectValue(let val):
			result = JSValue(object: val, in: mContext)
		@unknown default:
			CNLog(logLevel: .error, message: "Undefine type value", atFunction: #function, inFile: #file)
			result = JSValue(nullIn: mContext)
		}
		return result
	}

	public func convert(enumValue val: CNEnum) -> JSValue {
		return val.toJSValue(context: mContext)
	}

	public func convert(arrayValue val: Array<CNValue>) -> JSValue {
		let conv = CNValueToAnyObject()
		var result: Array<AnyObject> = []
		for elm in val {
			result.append(conv.convert(value: elm))
		}
		return JSValue(object: result, in: mContext)
	}

	public func convert(setValue val: Array<CNValue>) -> JSValue {
		let conv = CNValueToAnyObject()
		var result: Array<AnyObject> = []
		for elm in val {
			result.append(conv.convert(value: elm))
		}
		return JSValue(object: result, in: mContext)
	}

	public func convert(dictionaryValue val: Dictionary<String, CNValue>) -> JSValue {
		let conv = CNValueToAnyObject()
		var newdict: Dictionary<String, AnyObject> = [:]
		for (key, elm) in val {
			newdict[key] = conv.convert(value: elm)
		}
		return JSValue(object: newdict, in: mContext)
	}

}

