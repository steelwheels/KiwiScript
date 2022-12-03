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
			if let typestr = dict["type"]   as? String,
			   let membstr = dict["member"] as? String {
				return CNEnum.fromValue(typeName: typestr, memberName: membstr)
			}
		}
		return nil
	}

	func toJSValue(context ctxt: KEContext) -> JSValue {
		switch self.value {
		case .intValue(let ival):
			return JSValue(int32: Int32(ival), in: ctxt)
		case .stringValue(let sval):
			return JSValue(object: sval, in: ctxt)
		@unknown default:
			CNLog(logLevel: .error, message: "Undefined type", atFunction: #function, inFile: #file)
			return JSValue(int32: 0, in: ctxt)
		}
	}
}

