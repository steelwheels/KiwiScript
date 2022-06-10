/**
 * @file	KLValuePointer.swift
 * @brief	Extend CNValuePointer class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation

public extension CNPointerValue
{
	static func isPointer(scriptValue val: JSValue) -> Bool {
		if JSValue.hasClassName(value: val, className: CNPointerValue.ClassName) {
			if let dict = val.toDictionary() as? Dictionary<String, Any> {
				if let _ = dict[CNPointerValue.PathItem] as? String {
					return true
				}
			}
		}
		return false
	}

	static func fromJSValue(scriptValue val: JSValue) -> Result<CNPointerValue, NSError> {
		if let dict = val.toDictionary() as? Dictionary<String, Any> {
			if let pathstr = dict[CNPointerValue.PathItem] as? String {
				switch CNValuePath.pathExpression(string: pathstr) {
				case .success(let path):
					return .success(CNPointerValue(path: path))
				case .failure(let err):
					return .failure(err)
				}
			}
		}
		return .failure(NSError.parseError(message: "Incorrect format for pointer class"))
	}

	func toJSValue(context ctxt: KEContext) -> JSValue {
		let pathexp = NSString(string: self.path.expression)
		let result: Dictionary<String, NSObject> = [
			"class"			: NSString(string: CNPointerValue.ClassName),
			CNPointerValue.PathItem	: pathexp
		]
		return JSValue(object: result, in: ctxt)
	}
}

