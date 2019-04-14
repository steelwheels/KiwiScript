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
	case ImageType
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
		NSLog("Failed to convert to URL")
		return URL(string: "file:/dev/null")!
	}

	public convenience init(image img: CNImage, in context: KEContext){
		let imgobj = KLImage(context: context)
		imgobj.coreImage = img
		self.init(object: imgobj, in: context)
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
			} else if self.isImage {
				result = .ImageType
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
			NSLog("Undefined value is not supported")
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
		case .ImageType:
			result = .imageValue(self.toImage())
		case .RangeType:
			result = .rangeValue(self.toRange())
		case .PointType:
			if let point = valueToPoint(value: self) {
				result = .pointValue(point)
			} else {
				NSLog("Failed to convert: point")
				result = .nullValue
			}
		case .SizeType:
			if let size = valueToSize(value: self) {
				result = .sizeValue(size)
			} else {
				NSLog("Failed to convert: size")
				result = .nullValue
			}
		case .RectType:
			if let rect = valueToRect(value: self) {
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

	public func toText() -> CNText {
		let native = self.toNativeValue()
		return native.toText()
	}
}
