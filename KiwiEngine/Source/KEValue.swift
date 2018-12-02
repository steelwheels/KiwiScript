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
				result = .ObjectType
				if let obj = self.toObject() {
					if let _ = obj as? Dictionary<String, AnyObject> {
						result = .DictionaryType
					} else if let _ = obj as? NSRange {
						result = .RangeType
					} else if let _ = obj as? CGPoint {
						result = .PointType
					} else if let _ = obj as? CGSize {
						result = .SizeType
					} else if let _ = obj as? CGRect {
						result = .RectType
					}
				}
			} else {
				fatalError("Unknown type")
			}
			return result
		}
	}

	public func toNativeValue() -> CNNativeValue {
		let result: CNNativeValue
		switch self.type {
		case .UndefinedType:
			NSLog("Undefined value is not supported \(#function)")
			result = .nullValue
		case .NullType:
			result = .nullValue
		case .BooleanType:
			result = .booleanValue(self.toBool())
		case .NumberType:
			result = .numberValue(self.toNumber()!)
		case .StringType:
			result = .stringValue(self.toString())
		case .DateType:
			result = .dateValue(self.toDate())
		case .RangeType:
			result = .rangeValue(self.toRange())
		case .PointType:
			result = .pointValue(self.toPoint())
		case .SizeType:
			result = .sizeValue(self.toSize())
		case .RectType:
			result = .rectValue(self.toRect())
		case .ArrayType:
			let srcarr = self.toArray()!
			var dstarr: Array<CNNativeValue> = []
			for elm in srcarr {
				if let object = CNNativeValue.anyToValue(object: elm) {
					dstarr.append(object)
				} else {
					NSLog("Failed to convert at \(#function)")
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
						NSLog("Failed to convert at \(#function)")
					}
				}
			} else {
				NSLog("Failed to convert at \(#function)")
			}
			result = .dictionaryValue(dstdict)
		case .ObjectType:
			if let obj = self.toObject() as? NSObject {
				result = .objectValue(obj)
			} else {
				NSLog("Unknown object type")
				result = .nullValue
			}
		}
		return result
	}

	public func toText() -> CNText {
		let result: CNText
		switch self.type {
		case .UndefinedType:
			result = CNTextLine(string: "undefined")
		case .NullType:
			result = CNTextLine(string: "null")
		case .BooleanType, .NumberType, .StringType, .DateType, .RangeType, .PointType, .SizeType, .RectType:
			result = CNTextLine(string: "\(self.description)")
		case .ArrayType:
			if let arr = self.toArray() {
				let section = CNTextSection()
				section.header = "[" ; section.footer = "]"
				for elm in arr {
					if let obj = CNNativeValue.anyToValue(object: elm) {
						section.add(text: obj.toText())
					} else {
						NSLog("Unknown object at \(#function)")
						section.add(text: CNTextLine(string: "?"))
					}
				}
				result = section
			} else {
				result = CNTextLine(string: "\(self.description)")
			}
		case .DictionaryType:
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
							NSLog("Unknown object at \(#function)")
							section.add(text: CNTextLine(string: "?"))
						}
					} else {
						NSLog("Unknown object at \(#function)")
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
		case .booleanValue(let val):
			result = JSValue(bool: val, in: ctxt)
		case .numberValue(let val):
			result = JSValue(object: val, in: ctxt)
		case .stringValue(let val):
			result = JSValue(object: val, in: ctxt)
		case .dateValue(let val):
			result = JSValue(object: val, in: ctxt)
		case .rangeValue(let val):
			result = JSValue(object: val, in: ctxt)
		case .pointValue(let val):
			result = JSValue(point: val, in: ctxt)
		case .sizeValue(let val):
			result = JSValue(size: val, in: ctxt)
		case .rectValue(let val):
			result = JSValue(rect: val, in: ctxt)
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
}
