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

