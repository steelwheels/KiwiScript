/**
 * @file	KLSize.swift
 * @brief	Define KLSize class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation

public extension CGSize
{
	static func isSize(scriptValue val: JSValue) -> Bool {
		return val.isInterface(named: CGSize.InterfaceName)
	}

	static func fromJSValue(scriptValue val: JSValue) -> CGSize? {
		if let ifval = val.toInterface(named: CGPoint.InterfaceName) {
			if let wval = ifval.get(name: "width"), let hval = ifval.get(name: "height") {
				if let wnum = wval.toNumber(), let hnum = hval.toNumber() {
					return CGSize(width: wnum.doubleValue, height: hnum.doubleValue)
				}
			}
		}
		return nil
	}

	func toJSValue(context ctxt: KEContext) -> JSValue {
		return self.toValue().toJSValue(context: ctxt)
	}
}

