/**
 * @file	KLRange.swift
 * @brief	Define KLRange class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation

public extension NSRange
{
	init?(scriptValue val: JSValue) {
		if let dict = val.toDictionary() as? Dictionary<String, Any> {
			if let locnum = dict["location"] as? NSNumber,
			   let lennum = dict["length"] as? NSNumber {
				self.init(location: locnum.intValue, length: lennum.intValue)
				return
			}
		}
		return nil
	}

	func toJSValue(context ctxt: KEContext) -> JSValue {
		let locnum = NSNumber(integerLiteral: self.location)
		let lennum = NSNumber(integerLiteral: self.length)
		let result: Dictionary<String, NSObject> = [
			"class"    : NSString(string: NSRange.ClassName),
			"location" : locnum,
			"length"   : lennum
		]
		return JSValue(object: result, in: ctxt)
	}
}
