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
	static func isRange(scriptValue val: JSValue) -> Bool {
		if let dict = val.toDictionary() as? Dictionary<String, Any> {
			if let _ = dict["location"]  as? NSNumber,
			   let _ = dict["length"] as? NSNumber {
				return true
			} else {
				return false
			}
		} else {
			return false
		}
	}

	static func fromJSValue(scriptValue val: JSValue) -> NSRange? {
		if val.isRange {
			let range = val.toRange()
			return NSRange(location: range.location, length: range.length)
		} else if let dict = val.toDictionary() as? Dictionary<String, Any> {
			if let locnum = dict["location"] as? NSNumber,
			   let lennum = dict["length"] as? NSNumber {
				return NSRange(location: locnum.intValue, length: lennum.intValue)
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
