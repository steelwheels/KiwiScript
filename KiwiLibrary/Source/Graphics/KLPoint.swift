/**
 * @file	KLPoint.swift
 * @brief	Define KLPoint class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation

public extension CGPoint
{
	static func isPoint(scriptValue val: JSValue) -> Bool {
		return val.isInterface(named: CGPoint.InterfaceName)
	}

	static func fromJSValue(scriptValue val: JSValue) -> CGPoint? {
		if let ifval = val.toInterface(named: CGPoint.InterfaceName) {
			if let xval = ifval.get(name: "x"), let yval = ifval.get(name: "y") {
				if let xnum = xval.toNumber(), let ynum = yval.toNumber() {
					return CGPoint(x: xnum.doubleValue, y: ynum.doubleValue)
				}
			}
		}
		return nil
	}

	func toJSValue(context ctxt: KEContext) -> JSValue {
		return self.toValue().toJSValue(context: ctxt)
	}
}

