/**
 * @file	KLValueConverter.swift
 * @brief	Converter for CNValue and JSValue
 * @par Copyright
 *   Copyright (C) 2018-2019 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import CoconutDatabase
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
			case .enumType:		dupval = duplicate(enumValue: src.toEnum())
			case .URLType:		dupval = duplicate(urlValue: src.toURL())
			case .imageType:	dupval = duplicate(imageValue: src.toImage())
			case .colorType:	dupval = JSValue(object: src.toColor(), in: mTargetContext)
			case .arrayType:	dupval = duplicate(array: src.toArray())
			case .dictionaryType:	dupval = duplicate(dictionary: src.toDictionary())
			case .rangeType:	dupval = src.toRange().toJSValue(context: mTargetContext)
			case .pointType:	dupval = src.toPoint().toJSValue(context: mTargetContext)
			case .sizeType:		dupval = src.toSize().toJSValue(context: mTargetContext)
			case .rectType:		dupval = src.toRect().toJSValue(context: mTargetContext)
			case .recordType:	dupval = duplicate(recordValue: src.toRecord())
			case .objectType:	dupval = duplicate(object: src.toObject())
			case .referenceType:	dupval = duplicate(valueReference: src.toReference())
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

	private func duplicate(urlValue uval: URL?) -> JSValue {
		if let val = uval {
			let obj = KLURL(URL: val, context: mTargetContext)
			return JSValue(object: obj, in: mTargetContext)
		} else {
			return JSValue(nullIn: mTargetContext)
		}
	}

	private func duplicate(enumValue eval: CNEnum?) -> JSValue {
		if let val = eval {
			return val.toJSValue(context: mTargetContext)
		} else {
			return JSValue(nullIn: mTargetContext)
		}
	}

	private func duplicate(imageValue img: CNImage?) -> JSValue {
		if let val = img {
			return JSValue(image: val, in: mTargetContext)
		} else {
			return JSValue(nullIn: mTargetContext)
		}
	}

	private func duplicate(recordValue recp: CNRecord?) -> JSValue {
		let result: JSValue
		if let rec = recp {
			let recobj = KLRecord(record: rec, context: mTargetContext)
			result = JSValue(object: recobj, in: mTargetContext)
		} else {
			result = JSValue(nullIn: mTargetContext)
		}
		return result
	}

	private func duplicate(valueReference ref: CNValueReference?) -> JSValue {
		if let val = ref {
			return val.toJSValue(context: mTargetContext)
		} else {
			return JSValue(nullIn: mTargetContext)
		}
	}

	private func duplicate(object obj: Any?) -> JSValue {
		if let aval = obj {
			return JSValue(object: aval, in: mTargetContext)
		}
		CNLog(logLevel: .error, message: "Failed to duplicate: any", atFunction: #function, inFile: #file)
		return JSValue(undefinedIn: mTargetContext)
	}
}


