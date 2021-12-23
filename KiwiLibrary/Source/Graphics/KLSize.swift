/**
 * @file	KLSize.swift
 * @brief	Define KLSize class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation

public extension CGSize
{
	init?(scriptValue val: JSValue) {
		if let dict = val.toDictionary() as? Dictionary<String, Any> {
			if let wnum = dict["width"] as? NSNumber,
			   let hnum = dict["height"] as? NSNumber {
				self.init(width: wnum.doubleValue, height: hnum.doubleValue)
				return
			}
		}
		return nil
	}

	func toJSValue(context ctxt: KEContext) -> JSValue {
		let wnum = NSNumber(floatLiteral: Double(self.width))
		let hnum = NSNumber(floatLiteral: Double(self.height))
		let result: Dictionary<String, NSObject> = [
			"class"  : NSString(string: CGSize.ClassName),
			"width"  : wnum,
			"height" : hnum
		]
		return JSValue(object: result, in: ctxt)
	}
}

