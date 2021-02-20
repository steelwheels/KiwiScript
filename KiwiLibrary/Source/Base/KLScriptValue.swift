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

public enum JSValueType: Int {
	case UndefinedType
	case NullType
	case BooleanType
	case NumberType
	case StringType
	case DateType
	case URLType
	case ImageType
	case ArrayType
	case DictionaryType
	case RangeType
	case PointType
	case SizeType
	case RectType
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
			case .ImageType:	result = "image"
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
	public static let classPropertyName: String	= "className"
	public static let instancePropertyName: String	= "instanceName"

	public convenience init(URL url: URL, in context: KEContext) {
		let urlobj = KLURL(URL: url, context: context)
		self.init(object: urlobj, in: context)
	}

	public convenience init(image img: CNImage, in context: KEContext) {
		let imgobj = KLImage(context: context)
		imgobj.coreImage = img
		self.init(object: imgobj, in: context)
	}

	public func isClass(name nm: String) -> Bool {
		if let dict = self.toDictionary() {
			if let prop = dict[JSValue.classPropertyName] as? String {
				return (prop == nm)
			}
		}
		return false
	}

	public var isPoint: Bool {
		get {
			return isSpecialDictionary(keys: ["x", "y"])
		}
	}

	public func toPoint() -> CGPoint? {
		if let dict = self.toObject() as? Dictionary<AnyHashable, Any> {
			if let xval = anyToDouble(any: dict["x"]), let yval = anyToDouble(any: dict["y"]) {
				return CGPoint(x: xval, y: yval)
			}
		}
		return nil
	}

	public var isSize: Bool {
		get {
			return isSpecialDictionary(keys: ["width", "height"])
		}
	}

	public func toSize() -> CGSize? {
		if let dict = self.toObject() as? Dictionary<AnyHashable, Any> {
			if let wval = anyToDouble(any: dict["width"]), let hval = anyToDouble(any: dict["height"]) {
				return CGSize(width: wval, height: hval)
			}
		}
		return nil
	}

	public var isRect: Bool {
		get {
			return isSpecialDictionary(keys: ["x", "y", "width", "height"])
		}
	}

	public func toRect() -> CGRect? {
		if let dict = self.toObject() as? Dictionary<AnyHashable, Any> {
			if let x = anyToDouble(any: dict["x"]), let y = anyToDouble(any: dict["y"]), let width = anyToDouble(any: dict["width"]), let height = anyToDouble(any: dict["height"]) {
				return CGRect(x: x, y: y, width: width, height: height)
			}
		}
		return nil
	}

	public var isRange: Bool {
		get {
			let obj = self.toObject()
			if let _ = obj as? NSRange {
				return true
			} else {
				return isSpecialDictionary(keys: ["location", "length"])
			}
		}
	}

	public func toRange() -> NSRange? {
		if let range = self.toObject() as? NSRange {
			return range
		} else if let dict = self.toObject() as? Dictionary<AnyHashable, Any> {
			if let locval = anyToInt(any: dict["location"]), let lenval = anyToInt(any: dict["length"]) {
				return NSRange(location: locval, length: lenval)
			}
		}
		return nil
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
		NSLog("Failed to convert to URL")
		return URL(string: "file:/dev/null")!
	}

	public var isImage: Bool {
		get {
			if let imgobj = self.toObject() as? KLImage {
				if let _ = imgobj.coreImage {
					return true
				}
			}
			return false
		}
	}

	public func toImage() -> CNImage {
		if let imgobj = self.toObject() as? KLImage {
			if let img = imgobj.coreImage {
				return img
			}
		}
		NSLog("Failed to convert to image")
		return CNImage(data: Data(capacity: 16))!
	}

	private func isSpecialDictionary(keys dictkeys: Array<AnyHashable>) -> Bool {
		if let obj = self.toObject() {
			if let dict = obj as? Dictionary<AnyHashable, Any> {
				return isSpecialDictionary(keys: dictkeys, in: dict)
			}
		}
		return false
	}

	private func isSpecialDictionary(keys dictkeys: Array<AnyHashable>, in dict: Dictionary<AnyHashable, Any>) -> Bool {
		if dict.count == dictkeys.count {
			var haskey = true
			for key in dictkeys {
				if dict[key] == nil {
					haskey = false
					break
				}
			}
			if haskey {
				return true
			}
		}
		return false
	}

	private func anyToDouble(any aval: Any?) -> CGFloat? {
		if let val = aval as? CGFloat {
			return val
		} else if let val = aval as? Double {
			return CGFloat(val)
		} else if let val = aval as? NSNumber {
			return CGFloat(val.floatValue)
		} else {
			return nil
		}
	}

	private func anyToInt(any aval: Any?) -> Int? {
		if let val = aval as? Int {
			return val
		} else if let val = aval as? NSNumber {
			return val.intValue
		} else {
			return nil
		}
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
			} else if self.isRange {
				result = .RangeType
			} else if self.isPoint {
				result = .PointType
			} else if self.isSize {
				result = .SizeType
			} else if self.isRect {
				result = .RectType
			} else if self.isURL {
				result = .URLType
			} else if self.isImage {
				result = .ImageType
			} else if self.isObject {
				if let _ = self.toObject() as? Dictionary<AnyHashable, Any> {
					result = .DictionaryType
				} else if let _ = self.toObject() as? NSRange {
					result = .RangeType
				} else {
					result = .ObjectType
				}
			} else {
				fatalError("Unknown type: \"\(self.description)\"")
			}
			return result
		}
	}
	
	public func toNativeValue() -> CNNativeValue {
		let result: CNNativeValue
		switch self.type {
		case .UndefinedType:
			NSLog("Undefined value is not supported")
			result = .nullValue
		case .NullType:
			result = .nullValue
		case .BooleanType:
			let num = NSNumber(integerLiteral: self.toBool() ? 1: 0)
			result = .numberValue(num)
		case .NumberType:
			result = .numberValue(self.toNumber()!)
		case .StringType:
			result = .stringValue(self.toString())
		case .DateType:
			result = .dateValue(self.toDate())
		case .URLType:
			result = .URLValue(self.toURL())
		case .ImageType:
			result = .imageValue(self.toImage())
		case .RangeType:
			result = .rangeValue(self.toRange())
		case .PointType:
			if let point = self.toPoint() {
				result = .pointValue(point)
			} else {
				NSLog("Failed to convert: point")
				result = .nullValue
			}
		case .SizeType:
			if let size = self.toSize() {
				result = .sizeValue(size)
			} else {
				NSLog("Failed to convert: size")
				result = .nullValue
			}
		case .RectType:
			if let rect = self.toRect() {
				result = .rectValue(rect)
			} else {
				NSLog("Failed to convert: rect")
				result = .nullValue
			}
		case .ArrayType:
			let srcarr = self.toArray()!
			var dstarr: Array<CNNativeValue> = []
			for elm in srcarr {
				if let object = elementToValue(any: elm) {
					dstarr.append(object)
				} else {
					NSLog("Failed to convert: array")
				}
			}
			result = .arrayValue(dstarr)
		case .DictionaryType:
			var dstdict: Dictionary<String, CNNativeValue> = [:]
			if let srcdict = self.toDictionary() as? Dictionary<String, Any> {
				for (key, value) in srcdict {
					if let obj = elementToValue(any: value) {
						dstdict[key] = obj
					} else {
						NSLog("Failed to convert: dictionary")
					}
				}
			} else {
				NSLog("Failed to convert: dictionary")
			}
			result = CNNativeValue.dictionaryToValue(dictionary: dstdict)
		case .ObjectType:
			NSLog("Failed to convert: unknown")
			result = .nullValue
		}
		return result
	}

	private func elementToValue(any value: Any) -> CNNativeValue? {
		if let val = value as? JSValue {
			return val.toNativeValue()
		} else if let val = value as? KLURL {
			if let url = val.url {
				return CNNativeValue.anyToValue(object: url)
			} else {
				NSLog("Null URL")
				return .nullValue
			}
		} else if let val = value as? KLImage {
			if let image = val.coreImage {
				return CNNativeValue.anyToValue(object: image)
			} else {
				NSLog("Null image")
				return .nullValue
			}
		} else {
			return CNNativeValue.anyToValue(object: value)
		}
	}

	public func toText() -> CNText {
		let native = self.toNativeValue()
		return native.toText()
	}
}

