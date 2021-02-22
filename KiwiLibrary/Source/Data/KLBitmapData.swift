/**
 * @file	KLBitmapValue.swift
 * @brief	Define KLBitmapValue class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation

private let BitmapValueClassName = "BitmapValue"

extension JSValue
{
	public var isBitmapValue: Bool {
		get {
			return self.isClass(name: BitmapValueClassName)
		}
	}

	public func toBitmapValue() -> Array<Array<Int>>? {
		if isBitmapValue {
			if let dict = self.toDictionary() {
				if let data = dict["data"] as? Array<Array<Int>> {
					return data
				}
			}
		}
		return nil
	}
}

