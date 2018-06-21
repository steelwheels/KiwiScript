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
	case ArrayType
	case DictionaryType
	case DateType
	case ObjectType

	public var description: String {
		get {
			var result: String
			switch self {
			case .UndefinedType:	result = "undefined"
			case .NullType:		result = "null"
			case .BooleanType:	result = "bool"
			case .NumberType:	result = "float"
			case .StringType:	result = "string"
			case .ArrayType:	result = "array"
			case .DictionaryType:	result = "dictionary"
			case .DateType:		result = "date"
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

	public func type() -> JSValueType {
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
				}
			}
		} else {
			fatalError("Unknown type")
		}
		return result
	}
}
