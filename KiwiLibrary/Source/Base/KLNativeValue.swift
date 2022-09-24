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

extension CNValue
{
	public func toJSValue(context ctxt: KEContext) -> JSValue {
		let result: JSValue
		switch self {
		case .boolValue(let val):
			result = JSValue(bool: val, in: ctxt)
		case .numberValue(let val):
			result = JSValue(object: val, in: ctxt)
		case .stringValue(let val):
			result = JSValue(object: val, in: ctxt)
		case .enumValue(let val):
			result = val.toJSValue(context: ctxt)
		case .dictionaryValue(let dict):
			var newdict: Dictionary<String, Any> = [:]
			for (key, elm) in dict {
				newdict[key] = elm.toAny()
			}
			result = JSValue(object: newdict, in: ctxt)
		case .arrayValue(let arr):
			var newarr: Array<Any> = []
			for elm in arr {
				newarr.append(elm.toAny())
			}
			result = JSValue(object: newarr, in: ctxt)
		case .setValue(let sval):
			result = CNValueSet.valueToJSValue(source: sval, context: ctxt)
		case .objectValue(let val):
			if let _ = val as? NSNull {
				result = JSValue(nullIn: ctxt)
			} else {
				result = JSValue(object: val, in: ctxt)
			}
		@unknown default:
			result = JSValue(nullIn: ctxt)
		}
		return result
	}
}

