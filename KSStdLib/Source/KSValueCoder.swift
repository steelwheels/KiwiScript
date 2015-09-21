/**
 * @file		KSValueCoder.swift
 * @brief	Define functions for encoding/decoding values
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

public func KSAddMember<T : NSObject>(inout dict : Dictionary<String, AnyObject>, key : String, value : T)
{
	dict[key] = value
}

public func KSGetMember<T : NSObject>(dict : Dictionary<String, AnyObject>, key : String) -> T?
{
	if let val = dict[key] as? T {
		return val
	} else {
		return nil
	}
}

public func KSEncodePoint(src : CGPoint) -> Dictionary<String, AnyObject>
{
	let dict : Dictionary<String, AnyObject> = ["x":src.x, "y":src.y]
	return dict
}

public func KSDecodePoint(dict : Dictionary<String, AnyObject>) -> CGPoint?
{
	if let x = dict["x"] as? CGFloat {
		if let y = dict["y"] as? CGFloat {
			return CGPointMake(x, y)
		}
	}
	return nil
}

public func KSEncodeSize(src : CGSize) -> Dictionary<String, AnyObject>
{
	let dict : Dictionary<String, AnyObject> = ["width":src.width, "height":src.height]
	return dict
}

public func KSDecodeSize(dict : Dictionary<String, AnyObject>) -> CGSize?
{
	if let width = dict["width"] as? CGFloat {
		if let height = dict["height"] as? CGFloat {
			return CGSizeMake(width, height)
		}
	}
	return nil
}
