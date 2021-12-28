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
	static func fromJSValue(scriptValue val: JSValue) -> CGSize? {
		if val.isSize {
			let size = val.toSize()
			return CGSize(width: size.width, height: size.height)
		} else if let dict = val.toDictionary() as? Dictionary<String, Any> {
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

