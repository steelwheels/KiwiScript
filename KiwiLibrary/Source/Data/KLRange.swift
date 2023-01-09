/**
 * @file	KLRange.swift
 * @brief	Define KLRange class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation

public extension NSRange
{
	static func isRange(scriptValue val: JSValue) -> Bool {
		return val.isInterface(named: NSRange.InterfaceName)
	}

	static func fromJSValue(scriptValue val: JSValue) -> NSRange? {
		if let ifval = val.toInterface(named: NSRange.InterfaceName) {
			if let locval = ifval.get(name: "location"), let lenval = ifval.get(name: "length") {
				if let locnum = locval.toNumber(), let lennum = lenval.toNumber() {
					return NSRange(location: locnum.intValue, length: lennum.intValue)
				}
			}
		}
		return nil
	}

	func toJSValue(context ctxt: KEContext) -> JSValue {
		return self.toValue().toJSValue(context: ctxt)
	}
}
