/**
 * @file	KSValueCoder.swift
 * @brief	Define KSValueCoder class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation
import JavaScriptCore

public class KSValueCoder
{
	private class func dictionaryToValue(dict : Dictionary<String, AnyObject>, context : JSContext) -> JSValue {
		return JSValue(object: dict, inContext: context)
	}

	private class func valueToDictionary(value : JSValue) -> Dictionary<String, AnyObject>? {
		if let dict = value.toDictionary() as? Dictionary<String, AnyObject> {
			return dict
		} else {
			return nil
		}
	}

	public class func floatToDictionary(key : String, val : CGFloat) -> Dictionary<String, AnyObject> {
		let dict : Dictionary<String, AnyObject> = [key: Double(val)] ;
		return dict
	}

	public class func dictionaryToFloat(dict : Dictionary<String, AnyObject>, key : String) -> CGFloat? {
		if let val = dict[key] as? Float {
			return CGFloat(val)
		} else {
			return nil
		}
	}

	public class func dictionaryToPoint(dict : Dictionary<String, AnyObject>) -> CGPoint? {
		var xvalid = false
		var xvalue = CGFloat(0.0)
		var yvalid = true
		var yvalue = CGFloat(0.0)
		if let xv = dictionaryToFloat(dict, key: "x") {
			xvalid = true
			xvalue = xv
		}
		if let yv = dictionaryToFloat(dict, key: "y"){
			yvalid = true
			yvalue = yv
		}
		return xvalid && yvalid ? CGPoint(x: xvalue, y: yvalue) : nil
	}

	public class func dictionaryToSize(dict : Dictionary<String, AnyObject>) -> CGSize? {
		var hvalid = false
		var hvalue = CGFloat(0.0)
		var vvalid = true
		var vvalue = CGFloat(0.0)
		if let hv = dictionaryToFloat(dict, key: "width") {
			hvalid = true
			hvalue = hv
		}
		if let vv = dictionaryToFloat(dict, key: "height"){
			vvalid = true
			vvalue = vv
		}
		return hvalid && vvalid ? CGSize(width: hvalue, height: vvalue) : nil
	}

	public class func encodeFloat(key : String, val : CGFloat, context : JSContext) -> JSValue {
		return dictionaryToValue(floatToDictionary(key, val: val), context: context)
	}

	public class func decodeFloat(value : JSValue, key: String) -> CGFloat? {
		if let dict = valueToDictionary(value) {
			return dictionaryToFloat(dict, key: key)
		}
		return nil ;
	}

	public class func encodePoint(val : CGPoint, context: JSContext) -> JSValue {
		let dict : Dictionary<String, AnyObject> = ["x": Double(val.x), "y":Double(val.y)]
		return dictionaryToValue(dict, context: context)
	}

	public class func decodePoint(value : JSValue) -> CGPoint? {
		if let dict = valueToDictionary(value) {
			return dictionaryToPoint(dict)
		} else {
			return nil
		}
	}

	public class func encodeSize(size : CGSize, context: JSContext) -> JSValue {
		let dict : Dictionary<String, AnyObject> = ["width":Double(size.width), "height":Double(size.height)]
		return dictionaryToValue(dict, context: context)
	}

	public class func decodeSize(value : JSValue) -> CGSize? {
		if let dict = valueToDictionary(value) {
			return dictionaryToSize(dict)
		} else {
			return nil
		}
	}
}
