/**
 * @file	KLValueReference.swift
 * @brief	Extend CNValueReference class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation

public extension CNValueReference
{
	static func isValueReference(scriptValue val: JSValue) -> Bool {
		if let dict = val.toDictionary() as? Dictionary<String, Any> {
			if let _ = dict[CNValueReference.RelativePathItem] as? NSString {
				return true
			}
		}
		return false
	}

	static func fromJSValue(scriptValue val: JSValue) -> CNValueReference? {
		if let dict = val.toDictionary() as? Dictionary<String, Any> {
			if let pathstr = dict[CNValueReference.RelativePathItem] as? NSString {
				return CNValueReference(relativePath: pathstr as String)
			}
		}
		return nil
	}

	func toJSValue(context ctxt: KEContext) -> JSValue {
		let pathstr = NSString(string: self.relativePath)
		let result: Dictionary<String, NSObject> = [
			"class"                           : NSString(string: CNValueReference.ClassName),
			CNValueReference.RelativePathItem : pathstr
		]
		return JSValue(object: result, in: ctxt)
	}
}
