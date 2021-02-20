/**
 * @file	KLBitmapData.swift
 * @brief	Define KLBitmapData class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation

private let BitmapDataClassName	= "BitmapData"

extension JSValue
{
	public var isBitmap: Bool {
		get {
			return self.isClass(name: BitmapDataClassName)
		}
	}

	public func toBitmap() -> CNBitmapData? {
		if isBitmap {
			if let dict = self.toDictionary() {
				if let data = dict["data"] as? Array<Array<Int>> {
					return CNBitmapData(monoData: data)
				}
			}
		}
		return nil
	}
}

extension CNBitmapData
{
	public func toJSValue(context ctxt: KEContext) -> JSValue {
		let dict: Dictionary<String, Any> = [
			JSValue.classPropertyName:	BitmapDataClassName,
			"data":				self.data
		]
		return JSValue(object: dict, in: ctxt)
	}
}

