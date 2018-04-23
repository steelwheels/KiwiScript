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

extension CNValueType {
	public func toJSType() -> JSValueType {
		var result: JSValueType
		switch self {
		case .VoidType:
			result = .UndefinedType
		case .BooleanType:
			result = .BooleanType
		case .CharacterType:
			result = .StringType
		case .IntType, .UIntType, .FloatType, .DoubleType:
			result = .NumberType
		case .DateType:
			result = .DateType
		case .ArrayType:
			result = .ArrayType
		case .DictionaryType:
			result = .DictionaryType
		case .StringType:
			result = .StringType
		}
		return result
	}
}

extension CNValue
{
	public func toJSValue(context ctxt: JSContext) -> JSValue {
		var result: JSValue? = nil
		switch type {
		case .VoidType:
			result = JSValue(undefinedIn: ctxt)
		case .BooleanType:
			result = JSValue(bool: self.booleanValue!, in: ctxt)
		case .CharacterType:
			result = JSValue(object: NSString(string: "\(self.characterValue!)"), in: ctxt)
		case .IntType:
			result = JSValue(int32: Int32(self.intValue!), in: ctxt)
		case .UIntType:
			result = JSValue(int32: Int32(self.uIntValue!), in: ctxt)
		case .FloatType:
			result = JSValue(double: Double(self.floatValue!), in: ctxt)
		case .DoubleType:
			result = JSValue(double: Double(self.doubleValue!), in: ctxt)
		case .StringType:
			result = JSValue(object: NSString(string: "\(self.stringValue!)"), in: ctxt)
		case .DateType:
			result = JSValue(object: self.dateValue!, in: ctxt)
		case .ArrayType, .DictionaryType:
			if let obj = self.toObject() {
				result = JSValue(object: obj, in: ctxt)
			}
		}
		if let v = result {
			return v
		} else {
			fatalError("Can not covert")
		}
	}

	public func toObject() -> NSObject? {
		var result: NSObject?
		switch type {
		case .VoidType:
			result = nil
		case .BooleanType:
			result = NSNumber(value: self.booleanValue!)
		case .CharacterType:
			let c = self.characterValue!
			result = NSString(string: "\(c)")
		case .IntType:
			result = NSNumber(value: self.intValue!)
		case .UIntType:
			result = NSNumber(value: self.uIntValue!)
		case .FloatType:
			result = NSNumber(value: self.floatValue!)
		case .DoubleType:
			result = NSNumber(value: self.doubleValue!)
		case .StringType:
			result = NSString(string: self.stringValue!)
		case .DateType:
			let srcdate = self.dateValue!
			result = NSDate(timeIntervalSinceNow: srcdate.timeIntervalSinceNow)
		case .ArrayType:
			let newarray = NSMutableArray(capacity: 32)
			for elm in self.arrayValue! {
				if let elmobj = elm.toObject() {
					newarray.add(elmobj)
				} else {
					NSLog("Can not convert element: \(elm)")
				}
			}
			result = newarray
		case .DictionaryType:
			let newdict = NSMutableDictionary(capacity: 32)
			let srcdict = self.dictionaryValue!
			for key in srcdict.keys {
				if let elm = srcdict[key] {
					if let valobj = elm.toObject() {
						newdict.setValue(valobj, forKey: key)
					} else {
						fatalError("Can not happen")
					}
				}
			}
			return newdict
		}
		return result
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

	/* Reference: JavaScript Type-Conversion
	 *  http://jibbering.com/faq/notes/type-conversion/
	 */
	public func cast(to target: JSValueType, context ctxt: JSContext) -> JSValue? {
		let thistype = self.type()
		if thistype == target {
			return self
		}
		var result: JSValue? = nil
		switch target {
		case .UndefinedType:
			result = JSValue(undefinedIn: ctxt)
		case .NullType:
			if thistype == .UndefinedType {
				result = self // Undefined
			} else {
				result = JSValue(nullIn: ctxt)
			}
		case .BooleanType:
			switch thistype {
			case .UndefinedType, .NullType:
				result = JSValue(bool: false, in: ctxt)
			case .BooleanType:
				result = self // boolean
			case .NumberType:
				if let numobj = self.toNumber() {
					result = JSValue(bool: numobj.boolValue, in: ctxt)
				} else {
					fatalError("Can not happen")
				}
			case .StringType:
				let formatter = NumberFormatter()
				if let numobj = formatter.number(from: self.toString()) {
					result = JSValue(object: numobj, in: ctxt)
				} else {
					result = nil
				}
			case .ArrayType, .DictionaryType, .DateType, .ObjectType:
				result = JSValue(bool: true, in: ctxt)
			}
		case .NumberType:
			switch thistype {
			case .UndefinedType:
				result = self 	// undefined
			case .NullType:
				result = self	// null
			case .BooleanType:
				let ival: Int32
				if self.toBool() {
					ival = 1
				} else {
					ival = 0
				}
				result = JSValue(int32: ival, in: ctxt)
			case .NumberType:
				result = self	// number
			case .StringType:
				if let strobj = self.toString() {
					result = JSValue(object: strobj, in: ctxt)
				} else {
					result = JSValue(undefinedIn: ctxt)
				}
			case .ArrayType, .DictionaryType, .DateType, .ObjectType:
				result = nil
			}
		case .StringType:
			switch thistype {
			case .UndefinedType:
				result = self
			case .NullType:
				result = self
			default:
				if let strobj = self.toString() {
					result = JSValue(object: strobj, in: ctxt)
				} else {
					result = JSValue(undefinedIn: ctxt)
				}
			}
		case .ArrayType, .DictionaryType, .DateType, .ObjectType:
			result = nil
		}
		return result
	}

}
