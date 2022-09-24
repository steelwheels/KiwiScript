/**
 * @file	KLValueSet.swift
 * @brief	 Extend CNValueSet class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation

public extension CNValueSet
{
	static func isSet(scriptValue val: JSValue) -> Bool {
		if let dict = val.toDictionary() {
			if let str = dict["class"] as? String {
				return str == CNValueSet.ClassName
			}
		}
		return false
	}

	static func valueToJSValue(source src: Array<CNValue>, context ctxt: KEContext) -> JSValue {
		var values: Array<Any> = []
		for elm in src {
			values.append(elm.toAny())
		}
		let dict: Dictionary<String, Any> = [
			"class":	CNValueSet.ClassName,
			"values":	values
		]
		return JSValue(object: dict, in: ctxt)
	}

	static func fromJSValue(scriptValue val: JSValue) -> CNValue? {
		if let dict = val.toDictionary() as? Dictionary<String, Any> {
			var newdict: Dictionary<String, CNValue> = [:]
			for (key, aval) in dict {
				let val = CNValue.anyToValue(object: aval)
				newdict[key] = val
			}
			return CNValueSet.fromValue(value: newdict)
		} else {
			return nil
		}
	}
}
