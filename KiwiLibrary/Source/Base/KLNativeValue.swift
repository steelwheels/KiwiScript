/**
 * @file	KLNativeValue.swift
 * @brief	Extend CNNativeValue class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

extension CNNativeValue {
	public func toJSValue(context ctxt: KEContext) -> JSValue {
		let result: JSValue
		switch self {
		case .nullValue:
			result = JSValue(nullIn: ctxt)
		case .numberValue(let val):
			result = JSValue(object: val, in: ctxt)
		case .stringValue(let val):
			result = JSValue(object: val, in: ctxt)
		case .dateValue(let val):
			result = JSValue(object: val, in: ctxt)
		case .rangeValue(let val):
			let range = rangeToObject(range: val)
			result = JSValue(object: range, in: ctxt)
		case .pointValue(let val):
			let dict = pointToObject(point: val)
			result = JSValue(object: dict, in: ctxt)
		case .sizeValue(let val):
			let size = sizeToObject(size: val)
			result = JSValue(object: size, in: ctxt)
		case .rectValue(let val):
			let rect = rectToObject(point: val)
			result = JSValue(object: rect, in: ctxt)
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
		case .URLValue(let val):
			result = JSValue(URL: val, in: ctxt)
		case .imageValue(let val):
			result = JSValue(image: val, in: ctxt)
		case .anyObjectValue(let val):
			result = JSValue(object: val, in: ctxt)
		}
		return result
	}

	private func rangeToObject(range val: NSRange) -> Dictionary<String, Any> {
		let result: Dictionary<String, Any> = [
			"location":	NSNumber(value: Int(val.location)),
			"length":	NSNumber(value: Int(val.length))
		]
		return result
	}

	private func pointToObject(point val: CGPoint) -> Dictionary<String, Any> {
		let result: Dictionary<String, Any> = [
			"x":	NSNumber(value: Double(val.x)),
			"y":	NSNumber(value: Double(val.y))
		]
		return result
	}

	private func sizeToObject(size val: CGSize) -> Dictionary<String, Any> {
		let result: Dictionary<String, Any> = [
			"width":	NSNumber(value: Double(val.width)),
			"height":	NSNumber(value: Double(val.height))
		]
		return result
	}

	private func rectToObject(point val: CGRect) -> Dictionary<String, Any> {
		let result: Dictionary<String, Any> = [
			"origin":	pointToObject(point: val.origin),
			"size":		sizeToObject(size: val.size)
		]
		return result
	}
}

