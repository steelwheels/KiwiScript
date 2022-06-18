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
				if let val = CNValue.anyToValue(object: aval) {
					newdict[key] = val
				} else {
					CNLog(logLevel: .error, message: "Failed to convert", atFunction: #function, inFile: #file)
				}
			}
			return CNValueSet.fromValue(value: newdict)
		} else {
			return nil
		}
	}
}

/*
public extension CNValueSet
{
	static func isValueSet(scriptValue val: JSValue) -> Bool {
		if let dict = val.toDictionary() as? Dictionary<String, Any> {
			if let name = dict["class"] as? String {
				return name == CNValueSet.ClassName
			}
		}
		return false
	}

	static func fromJSValue(scriptValue val: JSValue) -> CNValueSet? {
		if let dict = val.toDictionary() as? Dictionary<String, Any> {
			if let name = dict["class"] as? String {
				if name == CNValueSet.ClassName {
					if let arr = dict["values"] as? Array<Any> {
						let newval = CNValueSet()
						for elm in arr {
							if let eval = CNValue.anyToValue(object: elm) {
								newval.insert(value: eval)
							} else {
								CNLog(logLevel: .error, message: "Failed to convert array element to value", atFunction: #function, inFile: #file)
								return nil // failed to convert
							}
							return newval
						}
					}
				}
			}
		}
		return nil
	}

	func toJSValue(context ctxt: KEContext) -> JSValue {
		let val: CNValue = .dictionaryValue(self.toValue())
		return val.toJSValue(context: ctxt)
	}
}
*/
