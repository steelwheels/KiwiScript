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
	public class func encode(value val: JSValue) -> Dictionary<String, AnyObject> {
		let topobj = encodeValue(value: val)
		let result : Dictionary<String, AnyObject> = ["value":topobj]
		return result
	}
	
	public class func decode(dictionary value: Dictionary<String, AnyObject>, inContext context: JSContext) -> JSValue {
		var result : JSValue
		if let content = value["value"] {
			result = decodeValue(value: content, inContext: context)
		} else {
			NSLog("Failed to decode value")
			result = JSValue(bool: false, inContext: context)
		}
		return result
	}
	
	private class func encodeValue(value val: JSValue) -> AnyObject {
		var result : AnyObject
		switch val.kind {
		case .UndefinedValue:
			result = NSNull()
		case .NilValue:
			result = NSNull()
		case .BooleanValue:
			result = val.toBool()
		case .NumberValue:
			result = val.toNumber()
		case .StringValue:
			result = val.toString()
		case .DateValue:
			result = val.toDate()
		case .ArrayValue:
			result = val.toArray()
		case .DictionaryValue:
			result = val.toDictionary()
		case .ObjectValue:
			result = val.toObject()
		}
		return result
	}
	
	private class func decodeValue(value val: AnyObject, inContext context: JSContext) -> JSValue {
		var result : JSValue
		if let _ = val as? NSNull {
			result = JSValue(nullInContext: context)
		} else if let boolval = val as? Bool {
			result = JSValue(bool: boolval, inContext: context)
		} else if let numval = val as? NSNumber {
			result = JSValue(double: numval.doubleValue, inContext: context)
		} else if let strval = val as? NSString {
			result = JSValue(object: strval, inContext: context)
		} else if let dataval = val as? NSDate {
			result = JSValue(object: dataval, inContext: context)
		} else if let arrval = val as? Array<AnyObject> {
			result = JSValue(object: NSArray(array: arrval), inContext: context)
		} else if let dictval = val as? Dictionary<String, AnyObject> {
			result = JSValue(object: NSDictionary(dictionary: dictval), inContext: context)
		} else if let objval = val as? NSObject {
			result = JSValue(object: objval, inContext: context)
		} else {
			fatalError("Unknown kind of object: \(val)")
		}
		return result
	}
}

