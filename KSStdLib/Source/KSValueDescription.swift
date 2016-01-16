/**
 * @file	KSValueDescription.swift
 * @brief	Define KSValueDescription class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation
import JavaScriptCore

public class KSValueDescription : KSValueVisitor
{
	public var valueString : String = ""
	
	public class func description(value : JSValue) -> String {
		let converter = KSValueDescription()
		converter.acceptValue(value)
		return converter.valueString
	}
	
	public override func visitUndefinedValue(value : JSValue){
		valueString = "undefined"
	}
	public override func visitNilValue(value : JSValue){
		valueString = "nil"
	}
	public override func visitBooleanValue(value : Bool){
		if value {
			valueString = "true"
		} else {
			valueString = "false"
		}
	}
	public override func visitNumberObject(number : NSNumber) {
		valueString = number.stringValue
	}
	public override func visitStringObject(string : NSString) {
		valueString = string as String
	}
	public override func visitDateObject(date : NSDate) {
		valueString = date.description
	}
	public override func visitDictionaryObject(dict : NSDictionary)	{
		var curstr = "["
		var is1st  = true
		for key in dict.allKeys {
			if is1st {
				is1st  = false
			} else {
				curstr = curstr + ", "
			}
			acceptElement(key)
			curstr = curstr + valueString + ":"
			if let val = dict.objectForKey(key) {
				acceptElement(val)
				curstr = curstr + valueString
			} else {
				fatalError("Can not happen")
			}
		}
		valueString = curstr + "]"
	}
	
	public override func visitArrayObject(arr : NSArray) {
		var curstr = "["
		var is1st  = true
		for elm in arr {
			if is1st {
				is1st  = false
			} else {
				curstr = curstr + ", "
			}
			acceptElement(elm)
			curstr = curstr + valueString
		}
		valueString = curstr + "]"
	}
	
	public override func visitUnknownObject(obj : NSObject)	{
		valueString = "unknown"
	}
	
	private func acceptElement(src : AnyObject) {
		if let elmval = src as? JSValue {
			acceptValue(elmval)
		} else if let elmobj = src as? NSObject {
			acceptObject(elmobj)
		} else {
			fatalError("Unknown object")
		}
	}
}

