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

public class KLValueDuplicator
{
	private var mTargetContext: KEContext

	public init(targetContext tgtctxt: KEContext) {
		mTargetContext = tgtctxt
	}

	public func duplicate(any aval: Any) -> Any {
		if let val = aval as? JSValue {
			return duplicate(value: val)
		} else if let val = aval as? Array<Any> {
			return duplicate(array: val)
		} else if let val = aval as? Dictionary<AnyHashable, Any> {
			return duplicate(dictionary: val)
		} else if let val = aval as? KLEmbeddedObject {
			return val.copy(context: mTargetContext)
		} else if let _ = aval as? String {
			return aval
		} else if let _ = aval as? NSNumber {
			return aval
		} else if let _ = aval as? NSRange {
			return aval
		} else if let _ = aval as? Date {
			return aval
		} else {
			NSLog("Failed to duplicate (1): \(String(describing: type(of: aval)))")
			return aval
		}
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
		case .ImageType:	dupval = JSValue(image: src.toImage(), in: mTargetContext)
		case .ArrayType:	dupval = duplicate(array: src.toArray())
		case .DictionaryType:	dupval = duplicate(dictionary: src.toDictionary())
		case .RangeType:	dupval = JSValue(range: src.toRange(), in: mTargetContext)
		case .PointType:	dupval = JSValue(point: src.toPoint(), in: mTargetContext)
		case .SizeType:		dupval = JSValue(size: src.toSize(), in: mTargetContext)
		case .RectType:		dupval = JSValue(rect: src.toRect(), in: mTargetContext)
		case .ObjectType:	dupval = duplicate(object: src.toObject())
		}
		return dupval
	}

	private func duplicate(array arrp: Array<Any>?) -> JSValue {
		var result: Array<Any> = []
		if let arr = arrp {
			for elm in arr {
				let dupval = duplicate(any: elm)
				result.append(dupval)
			}
		}
		return JSValue(object: result, in: mTargetContext)
	}

	private func duplicate(dictionary dictp: Dictionary<AnyHashable, Any>?) -> JSValue {
		var result: Dictionary<AnyHashable, Any> = [:]
		if let dict = dictp {
			for (key, val) in dict {
				let dupval = duplicate(any: val)
				result[key] = dupval
			}
		}
		return JSValue(object: result, in: mTargetContext)
	}

	private func duplicate(object obj: Any?) -> JSValue {
		if let aval = obj {
			if let val = duplicate(any: aval) as? JSValue {
				return val
			}
		}
		NSLog("Failed to duplicate (2)")
		return JSValue(undefinedIn: mTargetContext)
	}
}


