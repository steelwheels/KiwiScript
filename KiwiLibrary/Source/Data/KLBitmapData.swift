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
	public var isBitmap: Bool {
		get {
			return self.isClass(name: BitmapValueClassName)
		}
	}

	public func toBitmap() -> KLBitmapData? {
		if isBitmap {
			if let dict = self.toDictionary() {
				if let data = dict["data"] as? Array<Array<Int>> {
					let bm  = toBitmapObject(data: data)
					return KLBitmapData(bitmap: bm, context: self.context as! KEContext)
				}
			}
		}
		return nil
	}

	private func toBitmapObject(data src: Array<Array<Int>>) -> CNBitmapData {
		let fcol = CNPreference.shared.viewPreference.foregroundColor
		let bcol = CNColor.clear
		var dst: Array<Array<CNColor>> = []
		for srcline in src {
			var dstline: Array<CNColor> = []
			for srcpix in srcline {
				dstline.append(srcpix != 0 ? fcol : bcol)
			}
			dst.append(dstline)
		}
		return CNBitmapData(colorData: dst)
	}
}

@objc public protocol KLBitmapDataProtocol: JSExport {
	var 	width:		JSValue { get }
	var	height:		JSValue { get }

	func get(_ xval: JSValue, _ yval: JSValue) -> JSValue
	func set(_ xval: JSValue, _ yval: JSValue, _ data: JSValue) -> JSValue
	func clean()
}

@objc public class KLBitmapData: NSObject, KLBitmapDataProtocol {
	private var 	mBitmap:	CNBitmapData
	private var	mContext:	KEContext

	public init(bitmap bm: CNBitmapData, context ctxt: KEContext) {
		mBitmap		= bm
		mContext	= ctxt
	}

	public var core:   CNBitmapData { get { return mBitmap }}
	public var width:  JSValue { get { return JSValue(int32: Int32(mBitmap.width),  in: mContext) }}
	public var height: JSValue { get { return JSValue(int32: Int32(mBitmap.height), in: mContext) }}

	public func get(_ xval: JSValue, _ yval: JSValue) -> JSValue {
		if xval.isNumber && yval.isNumber {
			let x = Int(xval.toInt32())
			let y = Int(yval.toInt32())
			if let col = mBitmap.get(x: x, y: y) {
				let obj = KLColor(color: col, context: mContext)
				return JSValue(object: obj, in: mContext)
			}
		}
		return JSValue(nullIn: mContext)
	}

	public func set(_ xval: JSValue, _ yval: JSValue, _ data: JSValue) -> JSValue {
		guard xval.isNumber && yval.isNumber else {
			return JSValue(bool: false, in: mContext)
		}
		var result: Bool
		let x = Int(xval.toInt32())
		let y = Int(yval.toInt32())
		if let col = data.toObject() as? KLColor {
			mBitmap.set(x: x, y: y, color: col.core)
			result = true
		} else if let bm = data.toObject() as? KLBitmapData {
			mBitmap.set(x: x, y: y, bitmap: bm.core)
			result = true
		} else {
			NSLog("Invalid parameter: \(String(describing: data.toString()))")
			result = false
		}
		return JSValue(bool: result, in: mContext)
	}

	public func clean() {
		mBitmap.clean()
	}
}

