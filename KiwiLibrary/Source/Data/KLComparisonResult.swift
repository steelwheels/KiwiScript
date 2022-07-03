/**
 * @file	KLComparisonResult.swift
 * @brief	Extend ComparisonResult data type
 * @par Copyright
 *   Copyright (C) 20212Steel Wheels Project
 */

import CoconutData
import JavaScriptCore
import KiwiEngine

extension ComparisonResult {
	public static func fromScriptValue(_ val: JSValue) -> ComparisonResult? {
		if val.isNumber {
			if let num = val.toNumber() {
				if let res = ComparisonResult(rawValue: num.intValue) {
					return res
				}
			}
		}
		return nil
	}

	public func toScriptValue(context ctxt: KEContext) -> JSValue {
		return JSValue(int32: Int32(self.rawValue), in: ctxt)
	}
}
