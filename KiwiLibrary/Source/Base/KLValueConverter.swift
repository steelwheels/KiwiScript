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
			CNLog(logLevel: .error, message: "Failed to duplicate: \(String(describing: type(of: aval)))", atFunction: #function, inFile: #file)
			return aval
		}
	}

	public func duplicate(value src: JSValue) -> JSValue {
		let dupval: JSValue
		if let type = src.type {
			switch type {
			case .nullType:		dupval = JSValue(nullIn: mTargetContext)
			case .boolType:		dupval = JSValue(bool: src.toBool(), in: mTargetContext)
			case .numberType:	dupval = JSValue(object: src.toNumber(), in: mTargetContext)
			case .stringType:	dupval = JSValue(object: src.toString(), in: mTargetContext)
			case .dateType:		dupval = JSValue(object: src.toDate(), in: mTargetContext)
			case .enumType:		dupval = duplicate(dictionary: src.toEnum())
			case .URLType:		dupval = JSValue(URL: src.toURL(), in: mTargetContext)
			case .imageType:	dupval = JSValue(image: src.toImage(), in: mTargetContext)
			case .colorType:	dupval = JSValue(object: src.toColor(), in: mTargetContext)
			case .arrayType:	dupval = duplicate(array: src.toArray())
			case .dictionaryType:	dupval = duplicate(dictionary: src.toDictionary())
			case .rangeType:	dupval = JSValue(range: src.toRange(), in: mTargetContext)
			case .pointType:	dupval = JSValue(point: src.toPoint(), in: mTargetContext)
			case .sizeType:		dupval = JSValue(size: src.toSize(), in: mTargetContext)
			case .rectType:		dupval = JSValue(rect: src.toRect(), in: mTargetContext)
			case .objectType:	dupval = duplicate(object: src.toObject())
			@unknown default:
				CNLog(logLevel: .error, message: "Unknown case", atFunction: #function, inFile: #file)
				dupval = JSValue(undefinedIn: mTargetContext)
			}
		} else {
			dupval = JSValue(undefinedIn: mTargetContext)
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
			return JSValue(object: aval, in: mTargetContext)
		}
		CNLog(logLevel: .error, message: "Failed to duplicate: any", atFunction: #function, inFile: #file)
		return JSValue(undefinedIn: mTargetContext)
	}
}


