/**
 * @file	KLScriptValue.swift
 * @brief	Extend JSValue class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

public enum JSValueType {
	case UndefinedType
	case NullType
	case BooleanType
	case NumberType
	case StringType
	case DateType
	case URLType
	case ArrayType
	case DictionaryType
	case RangeType
	case RectType
	case PointType
	case SizeType
	case ObjectType

	public var description: String {
		get {
			var result: String
			switch self {
			case .UndefinedType:	result = "undefined"
			case .NullType:		result = "null"
			case .BooleanType:	result = "bool"
			case .NumberType:	result = "number"
			case .StringType:	result = "string"
			case .DateType:		result = "date"
			case .URLType:		result = "URL"
			case .ArrayType:	result = "array"
			case .DictionaryType:	result = "dictionary"
			case .RangeType:	result = "range"
			case .PointType:	result = "point"
			case .SizeType:		result = "size"
			case .RectType:		result = "rect"
			case .ObjectType:	result = "object"
			}
			return result
		}
	}
}

extension JSValue
{
	public convenience init(URL url: URL, in context: KEContext) {
		let urlobj = KLURL(URL: url, context: context)
		self.init(object: urlobj, in: context)
	}

	public var isURL: Bool {
		get {
			if let urlobj = self.toObject() as? KLURL {
				if let _ = urlobj.url {
					return true
				}
			}
			return false
		}
	}

	public func toURL() -> URL {
		if let urlobj = self.toObject() as? KLURL {
			if let url = urlobj.url {
				return url
			}
		}
		CNLog(type: .Error, message: "Failed to convert to URL", file: #file, line: #line, function: #function)
		return URL(string: "file:/dev/null")!
	}

	public var type: JSValueType {
		get {
			var result: JSValueType
			if self.isUndefined {
				result = .UndefinedType
			} else if self.isNull {
				result = .NullType
			} else if self.isBoolean {
				result = .BooleanType
			} else if self.isNumber {
				result = .NumberType
			} else if self.isString {
				result = .StringType
			} else if self.isArray {
				result = .ArrayType
			} else if self.isDate {
				result = .DateType
			} else if self.isURL {
				result = .URLType
			} else if self.isObject {
				if let dict = self.toObject() as? Dictionary<String, AnyObject> {
					if isPointObject(object: dict) {
						result = .PointType
					} else if isSizeObject(object: dict) {
						result = .SizeType
					} else if isRectObject(object: dict) {
						result = .RectType
					} else {
						result = .DictionaryType
					}
				} else {
					result = .ObjectType
				}
			} else {
				fatalError("Unknown type")
			}
			return result
		}
	}

	private func isPointObject(object obj: Dictionary<String, AnyObject>) -> Bool {
		if obj.count == 2 {
			if obj["x"] != nil && obj["y"] != nil {
				return true
			}
		}
		return false
	}

	private func isSizeObject(object obj: Dictionary<String, AnyObject>) -> Bool {
		if obj.count == 2 {
			if obj["width"] != nil && obj["height"] != nil {
				return true
			}
		}
		return false
	}

	private func isRectObject(object obj: Dictionary<String, AnyObject>) -> Bool {
		if obj.count == 2 {
			if let origin = obj["origin"] as? Dictionary<String, AnyObject> {
				if isPointObject(object: origin) {
					if let size = obj["size"] as? Dictionary<String, AnyObject> {
						return isSizeObject(object: size)
					}
				}
			}
		}
		return false
	}
	
	public func toNativeValue() -> CNNativeValue {
		let result: CNNativeValue
		switch self.type {
		case .UndefinedType:
			CNLog(type: .Error, message: "Undefined value is not supported", file: #file, line: #line, function: #function)
			result = .nullValue
		case .NullType:
			result = .nullValue
		case .BooleanType:
			let ival: Int = self.toBool() ? 1 : 0
			result = .numberValue(NSNumber(integerLiteral: ival))
		case .NumberType:
			result = .numberValue(self.toNumber()!)
		case .StringType:
			result = .stringValue(self.toString())
		case .DateType:
			result = .dateValue(self.toDate())
		case .URLType:
			result = .URLValue(self.toURL())
		case .RangeType:
			result = .rangeValue(self.toRange())
		case .PointType:
			if let point = valueToPoint(value: self) {
				result = .pointValue(point)
			} else {
				CNLog(type: .Error, message: "Failed to convert: point", file: #file, line: #line, function: #function)
				result = .nullValue
			}
		case .SizeType:
			if let size = valueToSize(value: self) {
				result = .sizeValue(size)
			} else {
				CNLog(type: .Error, message: "Failed to convert: size", file: #file, line: #line, function: #function)
				result = .nullValue
			}
		case .RectType:
			if let rect = valueToRect(value: self) {
				result = .rectValue(rect)
			} else {
				CNLog(type: .Error, message: "Failed to convert: rect", file: #file, line: #line, function: #function)
				result = .nullValue
			}
		case .ArrayType:
			let srcarr = self.toArray()!
			var dstarr: Array<CNNativeValue> = []
			for elm in srcarr {
				if let object = CNNativeValue.anyToValue(object: elm) {
					dstarr.append(object)
				} else {
					CNLog(type: .Error, message: "Failed to convert: array", file: #file, line: #line, function: #function)
				}
			}
			result = .arrayValue(dstarr)
		case .DictionaryType:
			var dstdict: Dictionary<String, CNNativeValue> = [:]
			if let srcdict = self.toDictionary() as? Dictionary<String, Any> {
				for (key, value) in srcdict {
					if let obj = CNNativeValue.anyToValue(object: value) {
						dstdict[key] = obj
					} else {
						CNLog(type: .Error, message: "Failed to convert: dictionary", file: #file, line: #line, function: #function)
					}
				}
			} else {
				CNLog(type: .Error, message: "Failed to convert: dictionary", file: #file, line: #line, function: #function)
			}
			result = CNNativeValue.dictionaryToValue(dictionary: dstdict)
		case .ObjectType:
			if let obj = self.toObject() as? NSObject {
				result = .objectValue(obj)
			} else {
				CNLog(type: .Error, message: "Failed to convert: unknown", file: #file, line: #line, function: #function)
				result = .nullValue
			}
		}
		return result
	}

	private func valueToPoint(value val: JSValue) -> CGPoint? {
		if let dict = val.toObject() as? Dictionary<String, AnyObject> {
			return valueToPoint(dictionary: dict)
		}
		return nil
	}

	private func valueToPoint(dictionary dict: Dictionary<String, AnyObject>) -> CGPoint? {
		if let xnum = dict["x"] as? NSNumber, let ynum = dict["y"] as? NSNumber {
			let x = CGFloat(xnum.doubleValue)
			let y = CGFloat(ynum.doubleValue)
			return CGPoint(x: x, y: y)
		}
		return nil
	}

	private func valueToSize(value val: JSValue) -> CGSize? {
		if let dict = val.toObject() as? Dictionary<String, AnyObject> {
			return valueToSize(dictionary: dict)
		}
		return nil
	}

	private func valueToSize(dictionary dict: Dictionary<String, AnyObject>) -> CGSize? {
		if let wnum = dict["width"] as? NSNumber, let hnum = dict["height"] as? NSNumber {
			let width  = CGFloat(wnum.doubleValue)
			let height = CGFloat(hnum.doubleValue)
			return CGSize(width: width, height: height)
		}
		return nil
	}

	private func valueToRect(value val: JSValue) -> CGRect? {
		if let dict = val.toObject() as? Dictionary<String, AnyObject> {
			if let odict = dict["origin"] as? Dictionary<String, AnyObject>,
				let hdict = dict["size"] as? Dictionary<String, AnyObject> {
				if let origin = valueToPoint(dictionary: odict),
					let size   = valueToSize(dictionary: hdict) {
					return CGRect(origin: origin, size: size)
				}
			}
		}
		return nil
	}
}

