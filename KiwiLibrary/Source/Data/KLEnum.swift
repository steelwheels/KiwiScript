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
			if let namestr = dict["name"]  as? NSString,
			   let valnum  = dict["value"] as? NSNumber {
				return CNEnum(name: namestr as String, value: valnum.intValue)
			}
		}
		return nil
	}

	func toJSValue(context ctxt: KEContext) -> JSValue {
		let namestr = NSString(string: self.name)
		let valnum  = NSNumber(integerLiteral: self.value)
		let result: Dictionary<String, NSObject> = [
			"class"   : NSString(string: CNEnum.ClassName),
			"name"    : namestr,
			"value"   : valnum
		]
		return JSValue(object: result, in: ctxt)
	}
}

