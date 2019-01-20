/**
 * @file	KEValue.swift
 * @brief	Define KEValue class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

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
	public class func castObject<T>(value val: JSValue) -> T? {
		if val.isObject {
			if let obj = val.toObject() as? T {
				return obj
			}
		}
		return nil
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
			CNLog(type: .Error, message: "Undefined value is not supported", place: #file)
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
		case .RangeType:
			result = .rangeValue(self.toRange())
		case .PointType:
			if let point = valueToPoint(value: self) {
				result = .pointValue(point)
			} else {
				CNLog(type: .Error, message: "Failed to convert: point", place: #file)
				result = .nullValue
			}
		case .SizeType:
			if let size = valueToSize(value: self) {
				result = .sizeValue(size)
			} else {
				CNLog(type: .Error, message: "Failed to convert: size", place: #file)
				result = .nullValue
			}
		case .RectType:
			if let rect = valueToRect(value: self) {
				result = .rectValue(rect)
			} else {
				CNLog(type: .Error, message: "Failed to convert: rect", place: #file)
				result = .nullValue
			}
		case .ArrayType:
			let srcarr = self.toArray()!
			var dstarr: Array<CNNativeValue> = []
			for elm in srcarr {
				if let object = CNNativeValue.anyToValue(object: elm) {
					dstarr.append(object)
				} else {
					CNLog(type: .Error, message: "Failed to convert: array", place: #file)
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
						CNLog(type: .Error, message: "Failed to convert: dictionary", place: #file)
					}
				}
			} else {
				CNLog(type: .Error, message: "Failed to convert: dictionary", place: #file)
			}
			result = CNNativeValue.dictionaryToValue(dictionary: dstdict)
		case .ObjectType:
			if let obj = self.toObject() as? NSObject {
				result = .objectValue(obj)
			} else {
				CNLog(type: .Error, message: "Failed to convert: unknown", place: #file)
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

	public func toText() -> CNText {
		let result: CNText
		switch self.type {
		case .UndefinedType:
			result = CNTextLine(string: "undefined")
		case .NullType:
			result = CNTextLine(string: "null")
		case .BooleanType, .NumberType, .StringType, .DateType, .RangeType:
			result = CNTextLine(string: "\(self.description)")
		case .ArrayType:
			if let arr = self.toArray() {
				let section = CNTextSection()
				section.header = "[" ; section.footer = "]"
				for elm in arr {
					if let obj = CNNativeValue.anyToValue(object: elm) {
						section.add(text: obj.toText())
					} else {
						CNLog(type: .Error, message: "Unknown object", place: #file)
						section.add(text: CNTextLine(string: "?"))
					}
				}
				result = section
			} else {
				result = CNTextLine(string: "\(self.description)")
			}
		case .DictionaryType, .PointType, .SizeType, .RectType:
			if let val = self.toDictionary() as? Dictionary<String, Any> {
				let keys = val.keys.sorted()
				let section = CNTextSection()
				section.header = "{" ; section.footer = "}"
				for key in keys {
					if let elm = val[key] {
						if let obj = CNNativeValue.anyToValue(object: elm) {
							let txt = obj.toText()
							if let line = txt as? CNTextLine {
								line.prepend(string: "\(key): ")
								section.add(text: line)
							} else {
								section.add(text: CNTextLine(string: "\(key): "))
								section.add(text: txt)
							}
						} else {
							CNLog(type: .Error, message: "Unknown object", place: #file)
							section.add(text: CNTextLine(string: "?"))
						}
					} else {
						CNLog(type: .Error, message: "Unknown object", place: #file)
						section.add(text: CNTextLine(string: "?"))
					}
				}
				result = section
			} else {
				result = CNTextLine(string: "\(self.description)")
			}
		case .ObjectType:
			result = CNTextLine(string: "\(self.description)")
		}
		return result
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
