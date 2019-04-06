/**
 * @file	KLValue.swift
 * @brief	Extend value objects
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

extension JSValue
{
	public func copy(context ctxt: KEContext) -> JSValue {
		let duplicator = KLValueDuplicator(targetContext: ctxt)
		return duplicator.duplicate(value: self)
	}
}

private class KLValueDuplicator
{
	private var mTargetContext: KEContext

	public init(targetContext tgtctxt: KEContext) {
		mTargetContext = tgtctxt
	}

	public func duplicate(value src: JSValue) -> JSValue {
		let dupval: JSValue
		switch src.type {
		case .UndefinedType:	dupval = JSValue(undefinedIn: mTargetContext)
		case .NullType:		dupval = JSValue(nullIn: mTargetContext)
		case .BooleanType:	dupval = JSValue(bool: src.toBool(), in: mTargetContext)
		case .NumberType:	dupval = JSValue(object: src.toNumber(), in: mTargetContext)
		case .StringType:	dupval = JSValue(object: src.toString(), in: mTargetContext)
		case .DateType:		dupval = JSValue(object: src.toDate(), in: mTargetContext)
		case .URLType:		dupval = JSValue(URL: src.toURL(), in: mTargetContext)
		case .ArrayType:	dupval = duplicateArray(array: src.toArray())
		case .DictionaryType:	dupval = duplicateDictionary(dictionary: src.toDictionary())
		case .RangeType:	dupval = JSValue(range: src.toRange(), in: mTargetContext)
		case .PointType:	dupval = JSValue(point: src.toPoint(), in: mTargetContext)
		case .SizeType:		dupval = JSValue(size: src.toSize(), in: mTargetContext)
		case .RectType:		dupval = JSValue(rect: src.toRect(), in: mTargetContext)
		case .ObjectType:	dupval = duplicateObject(object: src.toObject())
		}
		return dupval
	}

	private func duplicateArray(array arrp: Array<Any>?) -> JSValue {
		var result: Array<Any> = []
		if let arr = arrp {
			for elm in arr {
				if let eval = elm as? JSValue {
					result.append(duplicate(value: eval))
				} else if let eobj = elm as? KLEmbeddedObject {
					result.append(eobj.copy(context: mTargetContext))
				} else {
					result.append(elm)
				}
			}
		}
		return JSValue(object: result, in: mTargetContext)
	}

	private func duplicateDictionary(dictionary dictp: Dictionary<AnyHashable, Any>?) -> JSValue {
		var result: Dictionary<AnyHashable, Any> = [:]
		if let dict = dictp {
			for (key, val) in dict {
				if let eval = val as? JSValue {
					result[key] = duplicate(value: eval)
				} else if let eobj = val as? KLEmbeddedObject {
					result[key] = eobj.copy(context: mTargetContext)
				} else {
					result[key] = val
				}
			}
		}
		return JSValue(object: result, in: mTargetContext)
	}

	private func duplicateObject(object objp: Any?) -> JSValue {
		var result: Any?
		if let obj = objp as? JSValue {
			result = duplicate(value: obj)
		} else if let obj = objp as? KLEmbeddedObject {
			result = obj.copy(context: mTargetContext)
		} else {
			result = objp
		}
		return JSValue(object: result, in: mTargetContext)
	}
}

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
			result = JSValue(object: val, in: ctxt)
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
		case .objectValue(let val):
			result = JSValue(object: val, in: ctxt)
		}
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


