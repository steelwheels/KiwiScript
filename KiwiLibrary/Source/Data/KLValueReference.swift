/**
 * @file	KLValueSegment.swift
 * @brief	Extend CNValueReference class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation

public extension CNValueSegment
{
	static func isValueSegment(scriptValue val: JSValue) -> Bool {
		if let dict = val.toDictionary() as? Dictionary<String, Any> {
			if let _ = dict[CNValueSegment.RelativePathItem] as? NSString {
				return true
			}
		}
		return false
	}

	static func fromJSValue(scriptValue val: JSValue) -> CNValueSegment? {
		if let dict = val.toDictionary() as? Dictionary<String, Any> {
			if let pathstr = dict[CNValueSegment.RelativePathItem] as? NSString {
				return CNValueSegment(relativePath: pathstr as String)
			}
		}
		return nil
	}

	func toJSValue(context ctxt: KEContext) -> JSValue {
		let pathstr = NSString(string: self.relativePath)
		let result: Dictionary<String, NSObject> = [
			"class"				: NSString(string: CNValueSegment.ClassName),
			CNValueSegment.RelativePathItem	: pathstr
		]
		return JSValue(object: result, in: ctxt)
	}
}
