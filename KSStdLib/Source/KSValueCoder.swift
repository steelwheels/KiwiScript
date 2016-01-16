/**
* @file		KSValueCoder.swift
* @brief	Define KSValueCoder class
* @par Copyright
*   Copyright (C) 2015-2016 Steel Wheels Project
*/

import Foundation
import JavaScriptCore
import Canary

public class KSValueCoder
{
	public class func encode(value: JSValue) -> Dictionary<String, AnyObject> {
		let topobj = encodeValue(value)
		let result : Dictionary<String, AnyObject> = ["value":topobj]
		return result
	}
	
	public class func decode(value: Dictionary<String, AnyObject>, inContext context: JSContext) -> JSValue {
		var result : JSValue
		if let content = value["value"] {
			result = decodeValue(content, inContext: context)
		} else {
			NSLog("Failed to decode value")
			result = JSValue(bool: false, inContext: context)
		}
		return result
	}
	
	private class func encodeValue(value: JSValue) -> AnyObject {
		var result : AnyObject
		switch value.kind {
		case .UndefinedValue:
			result = NSNull()
		case .NilValue:
			result = NSNull()
		case .BooleanValue:
			result = value.toBool()
		case .NumberValue:
			result = value.toNumber()
		case .StringValue:
			result = value.toString()
		case .DateValue:
			result = value.toDate()
		case .ArrayValue:
			result = value.toArray()
		case .DictionaryValue:
			result = value.toDictionary()
		case .ObjectValue:
			result = value.toObject()
		}
		return result
	}
	
	private class func decodeValue(value: AnyObject, inContext context: JSContext) -> JSValue {
		var result : JSValue
		if let _ = value as? NSNull {
			result = JSValue(nullInContext: context)
		} else if let boolval = value as? Bool {
			result = JSValue(bool: boolval, inContext: context)
		} else if let numval = value as? NSNumber {
			result = JSValue(double: numval.doubleValue, inContext: context)
		} else if let strval = value as? NSString {
			result = JSValue(object: strval, inContext: context)
		} else if let dataval = value as? NSDate {
			result = JSValue(object: dataval, inContext: context)
		} else if let arrval = value as? Array<AnyObject> {
			result = JSValue(object: NSArray(array: arrval), inContext: context)
		} else if let dictval = value as? Dictionary<String, AnyObject> {
			result = JSValue(object: NSDictionary(dictionary: dictval), inContext: context)
		} else if let objval = value as? NSObject {
			result = JSValue(object: objval, inContext: context)
		} else {
			fatalError("Unknown kind of object: \(value)")
		}
		return result
	}
}

