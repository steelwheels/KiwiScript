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
	
	public class func description(value val: JSValue) -> String {
		let converter = KSValueDescription()
		converter.acceptValue(value: val)
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
	public override func visit(string s: String) {
		valueString = s as String
	}
	public override func visit(date d: Date) {
		valueString = d.description
	}
	public override func visit(dictionary d: [String:AnyObject])	{
		var curstr = "["
		var is1st  = true
		for (key, value) in d {
			if is1st {
				is1st  = false
			} else {
				curstr = curstr + ", "
			}
			curstr = curstr + key + ":"
			acceptElement(element: value)
			curstr = curstr + valueString
		}
		valueString = curstr + "]"
	}
	
	public override func visit(array a: [AnyObject]) {
		var curstr = "["
		var is1st  = true
		for elm in a {
			if is1st {
				is1st  = false
			} else {
				curstr = curstr + ", "
			}
			acceptElement(element: elm)
			curstr = curstr + valueString
		}
		valueString = curstr + "]"
	}
	
	public override func visit(object o: AnyObject)	{
		valueString = "unknown"
	}
	
	private func acceptElement(element src : AnyObject) {
		if let elmval = src as? JSValue {
			acceptValue(value: elmval)
		} else if let elmobj = src as? NSObject {
			acceptObject(object: elmobj)
		} else {
			fatalError("Unknown object")
		}
	}
}

