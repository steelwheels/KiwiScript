/**
 * @file	KLRect.swift
 * @brief	Define KLRect class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation

public extension CGRect
{
	static func isRect(scriptValue val: JSValue) -> Bool {
		return val.isInterface(named: CGRect.InterfaceName)
	}

	static func fromJSValue(scriptValue val: JSValue) -> CGRect? {
		if let ifval = val.toInterface(named: CGRect.InterfaceName) {
			if let xval = ifval.get(name: "x"),     let yval = ifval.get(name: "y"),
			   let wval = ifval.get(name: "width"), let hval = ifval.get(name: "height") {
				if let xnum = xval.toNumber(), let ynum = yval.toNumber(), let wnum = wval.toNumber(), let hnum = hval.toNumber() {
					return CGRect(x: xnum.doubleValue, y: ynum.doubleValue, width: wnum.doubleValue, height: hnum.doubleValue)
				}
			}
		}
		return nil
	}

	func toJSValue(context ctxt: KEContext) -> JSValue {
		return self.toValue().toJSValue(context: ctxt)
	}
}

