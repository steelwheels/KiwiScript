/**
 * @file	KEPropertyValue.swift
 * @brief	Define KEPropertyValue class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import JavaScriptCore
import Foundation

public class KEPropertyValue: NSObject
{
	private enum PropertyData {
		case UndefinedValue
		case NullValue
		case BooleanValue(value: Bool)
		case NumberValue(value: NSNumber)
		case StringValue(value: String)
		case ArrayValue(value: Array<Any>?)
		case DictionaryValue(value: Dictionary<AnyHashable, Any>)
		case DateValue(value: Date)
		case ObjectValue(value: JSManagedValue)
	}

	private var mData: PropertyData

	public init(value val: JSValue){
		if val.isUndefined {
			mData = .UndefinedValue
		} else if val.isNull {
			mData = .NullValue
		} else if val.isBoolean {
			mData = .BooleanValue(value: val.toBool())
		} else if val.isNumber {
			mData = .NumberValue(value: val.toNumber())
		} else if val.isString {
			mData = .StringValue(value: val.toString())
		} else if val.isArray {
			mData = .ArrayValue(value: val.toArray())
		} else if val.isDate {
			mData = .DateValue(value: val.toDate())
		} else {
			if let obj = JSManagedValue(value: val){
				mData = .ObjectValue(value: obj)
			} else {
				mData = .NullValue
			}
		}
	}

	public func toValue(context ctxt: JSContext) -> JSValue {
		var result: JSValue
		switch mData {
		case .UndefinedValue:
			result = JSValue(undefinedIn: ctxt)
		case .NullValue:
			result = JSValue(nullIn: ctxt)
		case .BooleanValue(let value):
			result = JSValue(bool: value, in: ctxt)
		case .NumberValue(let value):
			result = JSValue(object: value, in: ctxt)
		case .StringValue(let value):
			result = JSValue(object: value, in: ctxt)
		case .ArrayValue(let value):
			result = JSValue(object: value, in: ctxt)
		case .DictionaryValue(let value):
			result = JSValue(object: value, in: ctxt)
		case .DateValue(let value):
			result = JSValue(object: value, in: ctxt)
		case .ObjectValue(let mobject):
			result = mobject.value
		}
		return result
	}
}

