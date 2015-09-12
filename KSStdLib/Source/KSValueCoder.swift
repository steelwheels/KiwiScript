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
	public class func encodeFloat(key : String, val : CGFloat) -> Dictionary<String, AnyObject> {
		let dict : Dictionary<String, AnyObject> = [key: Double(val)] ;
		return dict
	}

	public class func decodeFloat(dict : Dictionary<NSObject, AnyObject>, key: String) -> CGFloat {
		var result : Double = 0.0
		if let value = dict[key] as? NSNumber {
			result = value.doubleValue
		} else {
			NSLog("No \"\(key)\" property in \(dict)")
		}
		return CGFloat(result)
	}
	
	public class func encodePoint(point : CGPoint) -> Dictionary<String, AnyObject> {
		let dict : Dictionary<String, AnyObject> = ["x": Double(point.x), "y":Double(point.y)]
		return dict
	}
	
	public class func decodePoint(dict : Dictionary<NSObject, AnyObject>) -> CGPoint {
		let x = decodeFloat(dict, key: "x")
		let y = decodeFloat(dict, key: "y")
		return CGPoint(x: x, y: y)
	}
	
	public class func encodeSize(size : CGSize) -> Dictionary<String, AnyObject> {
		let dict : Dictionary<String, AnyObject> = ["width":Double(size.width), "height":Double(size.height)]
		return dict
	}
	
	public class func decodeSize(dict : Dictionary<NSObject, AnyObject>) -> CGSize {
		let width  = decodeFloat(dict, key: "width")
		let height = decodeFloat(dict, key: "height")
		return CGSize(width: width, height: height)
	}
}
