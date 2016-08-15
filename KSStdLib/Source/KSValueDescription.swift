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
	
	public override func visit(undefinedValue value : JSValue){
		valueString = "undefined"
	}
	public override func visit(nilValue value : JSValue){
		valueString = "nil"
	}
	public override func visit(booleanValue value : Bool){
		if value {
			valueString = "true"
		} else {
			valueString = "false"
		}
	}
	public override func visit(number n: NSNumber) {
		valueString = n.stringValue
	}
	public override func visit(string s: NSString) {
		valueString = s as String
	}
	public override func visit(date d: NSDate) {
		valueString = d.description
	}
	public override func visit(dictionary d: NSDictionary)	{
		var curstr = "["
		var is1st  = true
		for key in d.allKeys {
			if is1st {
				is1st  = false
			} else {
				curstr = curstr + ", "
			}
			acceptElement(key)
			curstr = curstr + valueString + ":"
			if let val = d.objectForKey(key) {
				acceptElement(val)
				curstr = curstr + valueString
			} else {
				fatalError("Can not happen")
			}
		}
		valueString = curstr + "]"
	}
	
	public override func visit(array a: NSArray) {
		var curstr = "["
		var is1st  = true
		for elm in a {
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
	
	public override func visit(object o: NSObject)	{
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

