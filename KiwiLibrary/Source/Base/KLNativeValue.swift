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

extension CNValue {
	public func toJSValue(context ctxt: KEContext) -> JSValue {
		let result: JSValue
		switch self {
		case .nullValue:
			result = JSValue(nullIn: ctxt)
		case .boolValue(let val):
			result = JSValue(bool: val, in: ctxt)
		case .numberValue(let val):
			result = JSValue(object: val, in: ctxt)
		case .stringValue(let val):
			result = JSValue(object: val, in: ctxt)
		case .dateValue(let val):
			result = JSValue(object: val, in: ctxt)
		case .rangeValue(let val):
			result = val.toJSValue(context: ctxt)
		case .pointValue(let val):
			result = val.toJSValue(context: ctxt)
		case .sizeValue(let val):
			result = val.toJSValue(context: ctxt)
		case .rectValue(let val):
			result = val.toJSValue(context: ctxt)
		case .enumValue(let val):
			result = JSValue(int32: Int32(val.value), in: ctxt)
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
		case .URLValue(let val):
			result = JSValue(URL: val, in: ctxt)
		case .imageValue(let val):
			result = JSValue(image: val, in: ctxt)
		case .recordValue(let val):
			let recobj = KLRecord(record: val, context: ctxt)
			if let recval = KLRecord.allocate(record: recobj){
				result = recval
			} else {
				CNLog(logLevel: .error, message: "Failed to allocate", atFunction: #function, inFile: #file)
				result = JSValue(nullIn: ctxt)
			}
		case .objectValue(let val):
			result = JSValue(object: val, in: ctxt)
		case .colorValue(let col):
			let colval = col.escapeCode()
			result = JSValue(int32: colval, in: ctxt)
		case .segmentValue(let val):
			result = val.toJSValue(context: ctxt)
		case .pointerValue(let val):
			result = val.toJSValue(context: ctxt)
		@unknown default:
			result = JSValue(nullIn: ctxt)
		}
		return result
	}
}

