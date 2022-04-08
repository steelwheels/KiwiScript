/**
 * @file	KLValueSegment.swift
 * @brief	Extend CNValueSegment class
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
			if let _ = dict[CNValueSegment.FileItem] as? NSString {
				return true
			}
		}
		return false
	}

	static func fromJSValue(scriptValue val: JSValue) -> CNValueSegment? {
		if let dict = val.toDictionary() as? Dictionary<String, Any> {
			if let pathstr = dict[CNValueSegment.FileItem] as? NSString {
				return CNValueSegment(filePath: pathstr as String)
			}
		}
		return nil
	}

	func toJSValue(context ctxt: KEContext) -> JSValue {
		let pathstr = NSString(string: self.filePath)
		let result: Dictionary<String, NSObject> = [
			"class"			: NSString(string: CNValueSegment.ClassName),
			CNValueSegment.FileItem	: pathstr
		]
		return JSValue(object: result, in: ctxt)
	}
}
