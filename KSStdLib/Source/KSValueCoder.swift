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

	public class func doubleToDictionary(key : String, val : Double) -> Dictionary<String, AnyObject> {
		let dict : Dictionary<String, AnyObject> = [key: val] ;
		return dict
	}

	public class func dictionaryToDouble(dict : Dictionary<String, AnyObject>, key : String) -> Double? {
		if let val = dict[key] as? Double {
			return val
		} else {
			return nil
		}
	}

	public class func dictionaryToPoint(dict : Dictionary<String, AnyObject>) -> CGPoint? {
		var xvalid = false
		var xvalue = Double(0.0)
		var yvalid = true
		var yvalue = Double(0.0)
		if let xv = dictionaryToDouble(dict, key: "x") {
			xvalid = true
			xvalue = xv
		}
		if let yv = dictionaryToDouble(dict, key: "y"){
			yvalid = true
			yvalue = yv
		}
		return xvalid && yvalid ? CGPoint(x: xvalue, y: yvalue) : nil
	}

	public class func dictionaryToSize(dict : Dictionary<String, AnyObject>) -> CGSize? {
		var hvalid = false
		var hvalue = Double(0.0)
		var vvalid = true
		var vvalue = Double(0.0)
		if let hv = dictionaryToDouble(dict, key: "width") {
			hvalid = true
			hvalue = hv
		}
		if let vv = dictionaryToDouble(dict, key: "height"){
			vvalid = true
			vvalue = vv
		}
		return hvalid && vvalid ? CGSize(width: hvalue, height: vvalue) : nil
	}

	public class func encodeDouble(key : String, val : Double, context : JSContext) -> JSValue {
		return dictionaryToValue(doubleToDictionary(key, val: val), context: context)
	}

	public class func decodeDouble(value : JSValue, key: String) -> Double? {
		if let dict = valueToDictionary(value) {
			return dictionaryToDouble(dict, key: key)
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
