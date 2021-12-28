/**
 * @file	KLRect.swift
 * @brief	Define KLRect class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation

public extension CGRect
{
	static func fromJSValue(scriptValue val: JSValue) -> CGRect? {
		if val.isRect {
			let rect = val.toRect()
			return CGRect(origin: rect.origin, size: rect.size)
		} else if let dict = val.toDictionary() as? Dictionary<String, Any> {
			if let xnum = dict["x"]      as? NSNumber,
			   let ynum = dict["y"]      as? NSNumber,
			   let wnum = dict["width"]  as? NSNumber,
			   let hnum = dict["height"] as? NSNumber {
				return CGRect(x: xnum.doubleValue, y: ynum.doubleValue, width: wnum.doubleValue, height: hnum.doubleValue)
			}
		}
		return nil
	}

	func toJSValue(context ctxt: KEContext) -> JSValue {
		let xnum = NSNumber(floatLiteral: Double(self.origin.x))
		let ynum = NSNumber(floatLiteral: Double(self.origin.y))
		let wnum = NSNumber(floatLiteral: Double(self.size.width))
		let hnum = NSNumber(floatLiteral: Double(self.size.height))
		let result: Dictionary<String, NSObject> = [
			"class"  : NSString(string: CGRect.ClassName),
			"x"      : xnum,
			"y"      : ynum,
			"width"	 : wnum,
			"height" : hnum
		]
		return JSValue(object: result, in: ctxt)
	}
}

