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
	static func isSize(scriptValue val: JSValue) -> Bool {
		if let dict = val.toDictionary() as? Dictionary<String, Any> {
			if let _ = dict["width"]  as? NSNumber,
			   let _ = dict["height"] as? NSNumber {
				return true
			} else {
				return false
			}
		} else {
			return false
		}
	}

	static func fromJSValue(scriptValue val: JSValue) -> CGSize? {
		if let dict = val.toDictionary() as? Dictionary<String, Any> {
			if let wnum = dict["width"] as? NSNumber,
			   let hnum = dict["height"] as? NSNumber {
				return CGSize(width: wnum.doubleValue, height: hnum.doubleValue)
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

