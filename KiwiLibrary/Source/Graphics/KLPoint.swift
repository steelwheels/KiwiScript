/**
 * @file	KLPoint.swift
 * @brief	Define KLPoint class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation

public extension CGPoint
{
	init?(scriptValue val: JSValue) {
		if let dict = val.toDictionary() as? Dictionary<String, Any> {
			if let xnum = dict["x"] as? NSNumber,
			   let ynum = dict["y"] as? NSNumber {
				self.init(x: xnum.doubleValue, y: ynum.doubleValue)
				return
			}
		}
		return nil
	}

	func toJSValue(context ctxt: KEContext) -> JSValue {
		let xnum = NSNumber(floatLiteral: Double(self.x))
		let ynum = NSNumber(floatLiteral: Double(self.y))
		let result: Dictionary<String, NSObject> = [
			"class" : NSString(string: CGPoint.ClassName),
			"x"     : xnum,
			"y"     : ynum
		]
		return JSValue(object: result, in: ctxt)
	}
}

