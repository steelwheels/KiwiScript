/**
 * @file	KLValueConverter.swift
 * @brief	Converter for CNNativeValue and JSValue
 * @par Copyright
 *   Copyright (C) 2018-2019 Steel Wheels Project
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


