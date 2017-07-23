/**
 * @file	KEValue.swift
 * @brief	Extend JSValue class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Canary
import JavaScriptCore
import Foundation

extension JSValue
{
	public enum ValueType: Int {
	case Undefined
	case Null
	case Boolean
	case Number
	case String
	case Object
	case Array
	case Dictionary
	case Date
	}

	public var type: ValueType {
		get {
			var result: ValueType
			if self.isNull {
				result = .Null
			} else if self.isBoolean {
				result = .Boolean
			} else if self.isNumber {
				result = .Number
			} else if self.isString {
				result = .String
			} else if self.isObject {
				let obj = self.toObject()
				if let _ = obj as? NSDictionary {
					result = .Dictionary
				} else {
					result = .Object
				}
			} else if self.isArray {
				result = .Array
			} else if self.isDate {
				result = .Date
			} else {
				result = .Undefined
			}
			return result
		}
	}

	public func cast(to type: CNValueType) -> JSValue?
	{
		var result: JSValue?
		switch self.type {
		case .Null, .Undefined:
			result = nil
		case .Boolean:
			switch type {
			case .BooleanType:
				result = self
			default:
				result = nil
			}
		case .Number:
			switch type {
			case .BooleanType, .IntType, .UIntType, .FloatType, .DoubleType:
				result = self
			default:
				result = nil
			}
		case .String:
			switch type {
			case .StringType:
				result = self
			default:
				result = nil
			}
		case .Object:
			break
		case .Array:
			break
		case .Dictionary:
			break
		case .Date:
			break

		}
		return result
	}
}

open class KEValueVisitor: CNVisitor
{
	public func accept(value val: JSValue) {
		if val.isNull {
			visitNull()
		} else if val.isBoolean {
			visit(bool: val.toBool())
		} else if val.isNumber {
			accept(number: val.toNumber())
		} else if val.isString {
			visit(string: val.toString())
		} else if val.isDate {
			visit(date: val.toDate())
		} else if val.isObject {
			if let obj = val.toObject() {
				if let arr  = obj as? Array<Any> {
					visit(array: arr)
				} else if let dict = obj as? Dictionary<AnyHashable,Any> {
					visit(dictionary: dict)
				} else  {
					visit(any: obj)
				}
			} else {
				visitNull()
			}
		} else if val.isArray {
			visit(array: val.toArray())
		} else {
			visitUndefined()
		}
	}

	open func visitNull()						{	}
	open func visitUndefined()					{	}

	open override func visit(any v: Any){
		let cname = className(any: v)
		NSLog("any = \(cname)")
	}

	private func className(any v: Any) -> String
	{
		return String(describing: type(of: v))
	}
}

public class KEValueConverter
{
	public class func convert(source src: CNValue, context ctxt: KEContext) -> JSValue {
		var result: JSValue
		switch src.type {
		case .VoidType:
			result = JSValue(int32: Int32(0), in: ctxt)
		case .BooleanType:
			result = JSValue(bool: src.booleanValue!, in: ctxt)
		case .CharacterType:
			let v = src.characterValue!
			result = JSValue(object: "\(v)", in: ctxt)
		case .IntType:
			let v = src.intValue!
			result = JSValue(int32: Int32(v), in: ctxt)
		case .UIntType:
			let v = src.uIntValue!
			result = JSValue(uInt32: UInt32(v), in: ctxt)
		case .FloatType:
			let v = src.floatValue!
			result = JSValue(double: Double(v), in: ctxt)
		case .DoubleType:
			let v = src.doubleValue!
			result = JSValue(double: v, in: ctxt)
		case .StringType:
			let v = src.stringValue!
			result = JSValue(object: v, in: ctxt)
		case .DateType:
			let v = src.dateValue!
			result = JSValue(object: v, in: ctxt)
		case .ArrayType:
			var array: Array<NSObject> = []
			let v = src.arrayValue!
			for elm in v {
				let elmobj = KEValueConverter.convertToObject(source: elm)
				array.append(elmobj)
			}
			result = JSValue(object: array, in: ctxt)
		case .SetType:
			var array: Array<NSObject> = []
			let v = src.setValue!
			for elm in v {
				let elmobj = KEValueConverter.convertToObject(source: elm)
				array.append(elmobj)
			}
			result = JSValue(object: array, in: ctxt)
		case .DictionaryType:
			let v = src.dictionaryValue!
			var dict: Dictionary<String, NSObject> = [:]
			for key in v.keys {
				if let elm = v[key] {
					let elmobj = KEValueConverter.convertToObject(source: elm)
					dict[key] = elmobj
				} else {
					fatalError("could not convert")
				}
			}
			result = JSValue(object: dict, in: ctxt)
		}
		return result
	}

	private class func convertToObject(source src: CNValue) -> NSObject
	{
		var result: NSObject
		switch src.type {
		case .VoidType:
			result = NSNumber(integerLiteral: 0)
		case .BooleanType:
			let v = src.booleanValue!
			result = NSNumber(booleanLiteral: v)
		case .CharacterType:
			let v = src.characterValue!
			result = NSString(string: "\(v)")
		case .IntType:
			let v = src.intValue!
			result = NSNumber(value: v)
		case .UIntType:
			let v = src.uIntValue!
			result = NSNumber(value: v)
		case .FloatType:
			let v = src.floatValue!
			result = NSNumber(value: v)
		case .DoubleType:
			let v = src.doubleValue!
			result = NSNumber(value: v)
		case .StringType:
			let v = src.stringValue!
			result = NSString(string: v)
		case .DateType:
			let v = src.dateValue!
			result = v as NSDate
		case .ArrayType:
			let array = NSMutableArray(capacity: 8)
			let v = src.arrayValue!
			for elm in v {
				let elmobj = KEValueConverter.convertToObject(source: elm)
				array.add(elmobj)
			}
			result = array
		case .SetType:
			let array = NSMutableArray(capacity: 8)
			let v = src.setValue!
			for elm in v {
				let elmobj = KEValueConverter.convertToObject(source: elm)
				array.add(elmobj)
			}
			result = array
		case .DictionaryType:
			let dict = NSMutableDictionary(capacity: 8)
			let v = src.dictionaryValue!
			for key in v.keys {
				if let elm = v[key] {
					let elmobj = KEValueConverter.convertToObject(source: elm)
					dict[key] = elmobj
				} else {
					fatalError("could not convert")
				}
			}
			result = dict
		}
		return result
	}
}

