/**
 * @file	KSValueExtension.swift
 * @brief	Extend JSValue class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation
import JavaScriptCore

public enum KSValueKind {
	case UndefinedValue
	case NilValue
	case BooleanValue
	case NumberValue
	case StringValue
	case DateValue
	case ArrayValue
	case DictionaryValue
	case ObjectValue
	
	public func toString() -> String {
		var result = "?"
		switch self {
		case .UndefinedValue:
			result = "Undefined"
		case .NilValue:
			result = "Nil"
		case .BooleanValue:
			result = "Boolean"
		case .NumberValue:
			result = "Number"
		case .StringValue:
			result = "String"
		case .DateValue:
			result = "Date"
		case .ArrayValue:
			result = "Array"
		case .DictionaryValue:
			result = "Dictionary"
		case .ObjectValue:
			result = "Object"
		}
		return result ;
	}
}

public extension JSValue
{
	public var kind : KSValueKind {
		get {
			var result = KSValueKind.UndefinedValue
			if self.isUndefined {
				result = .UndefinedValue
			} else if self.isNull {
				result = .NilValue
			} else if self.isBoolean {
				result = .BooleanValue
			} else if self.isNumber {
				result = .NumberValue
			} else if self.isString {
				result = .StringValue
			} else if self.isObject {
				if let _ = self.toDictionary() {
					result = .DictionaryValue
				} else if let _ = self.toArray() {
					result = .ArrayValue
				} else if let _ = self.toDate() {
					result = .DateValue
				} else {
					result = .ObjectValue
				}
			}
			return result
		}
	}
}

