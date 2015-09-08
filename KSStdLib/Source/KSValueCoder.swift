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
	public class func decodeFloat(dict : Dictionary<NSObject, AnyObject>, key: String) -> CGFloat {
		var result : CGFloat = 0.0
		if let value = dict[key] as? CGFloat {
			result = value
		} else {
			NSLog("No \"\(key)\" property in \(dict)")
		}
		return result
	}
	
	public class func encodePoint(point : CGPoint) -> Dictionary<String, AnyObject> {
		let dict : Dictionary<String, AnyObject> = ["x":point.x, "y":point.y]
		return dict
	}
	
	public class func decodePoint(dict : Dictionary<NSObject, AnyObject>) -> CGPoint {
		let x = decodeFloat(dict, key: "x")
		let y = decodeFloat(dict, key: "y")
		return CGPoint(x: x, y: y)
	}
	
	public class func encodeSize(size : CGSize) -> Dictionary<String, AnyObject> {
		let dict : Dictionary<String, AnyObject> = ["width":size.width, "height":size.height]
		return dict
	}
	
	public class func decodeSize(dict : Dictionary<NSObject, AnyObject>) -> CGSize {
		let width  = decodeFloat(dict, key: "width")
		let height = decodeFloat(dict, key: "height")
		return CGSize(width: width, height: height)
	}
}
