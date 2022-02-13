/**
 * @file	KLEnum.swift
 * @brief	Extend CNEnum class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation

public extension CNEnum
{
	static func isEnum(scriptValue val: JSValue) -> Bool {
		if let dict = val.toDictionary() as? Dictionary<String, Any> {
			if let _ = dict["type"]  as? NSString,
			   let _ = dict["value"] as? NSNumber {
				return true
			} else {
				return false
			}
		} else {
			return false
		}
	}

	static func fromJSValue(scriptValue val: JSValue) -> CNEnum? {
		if let dict = val.toDictionary() as? Dictionary<String, Any> {
			if let typestr = dict["type"] as? NSString,
			   let valnum  = dict["value"] as? NSNumber {
				return CNEnum(type: typestr as String, value: valnum.intValue)
			}
		}
		return nil
	}

	func toJSValue(context ctxt: KEContext) -> JSValue {
		let typestr = NSString(string: self.type)
		let valnum  = NSNumber(integerLiteral: self.value)
		let result: Dictionary<String, NSObject> = [
			"class"   : NSString(string: CNEnum.ClassName),
			"type"    : typestr,
			"value"   : valnum
		]
		return JSValue(object: result, in: ctxt)
	}
}

