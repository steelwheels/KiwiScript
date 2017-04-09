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
			result = JSValue(bool: false, in: context)
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
			let v = val.toBool()
			result = NSNumber(value: v)
		case .NumberValue:
			result = val.toNumber()
		case .StringValue:
			if let v = val.toString() {
				result = NSString(string: v)
			} else {
				result = NSString(string: "")
			}
		case .DateValue:
			if let v = val.toDate() {
				result = v as NSDate
			} else {
				result = NSDate(timeIntervalSinceNow: 0)
			}
		case .ArrayValue:
			let arr = NSMutableArray(capacity: 8)
			for elm in val.toArray() {
				arr.add(elm as AnyObject)
			}
			result = arr
		case .DictionaryValue:
			let dict = NSMutableDictionary(capacity: 8)
			for (k, v) in val.toDictionary() {
				if let key = k as? NSString {
					dict.setObject(v, forKey: key)
				} else {
					fatalError("Invalid key type")
				}
			}
			result = dict
		case .ObjectValue:
			if let obj = val.toObject() as? NSObject {
				result = obj
			} else {
				fatalError("Invalid object type")
			}
		}
		return result
	}
	
	private class func decodeValue(value val: AnyObject, inContext context: JSContext) -> JSValue {
		var result : JSValue
		if let _ = val as? NSNull {
			result = JSValue(nullIn: context)
		} else if let boolval = val as? Bool {
			result = JSValue(bool: boolval, in: context)
		} else if let numval = val as? NSNumber {
			result = JSValue(double: numval.doubleValue, in: context)
		} else if let strval = val as? NSString {
			result = JSValue(object: strval, in: context)
		} else if let dataval = val as? NSDate {
			result = JSValue(object: dataval, in: context)
		} else if let arrval = val as? Array<AnyObject> {
			result = JSValue(object: NSArray(array: arrval), in: context)
		} else if let dictval = val as? Dictionary<String, AnyObject> {
			result = JSValue(object: NSDictionary(dictionary: dictval), in: context)
		} else if let objval = val as? NSObject {
			result = JSValue(object: objval, in: context)
		} else {
			fatalError("Unknown kind of object: \(val)")
		}
		return result
	}
}

