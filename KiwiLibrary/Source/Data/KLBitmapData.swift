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

@objc public protocol KLBitmapDataProtocol: JSExport
{
	func set(_ x: JSValue, _ y: JSValue, _ col: JSValue)
	func get(_ x: JSValue, _ y: JSValue) -> JSValue
}

@objc public class KLBitmapData: NSObject, KLBitmapDataProtocol
{
	private var mBitmapData:	CNBitmapData
	private var mContext:		KEContext
	private var mConsole:		CNConsole

	public var data: CNBitmapData { get { return mBitmapData }}

	public init(bitmap bm: CNBitmapData, context ctxt: KEContext, console cons: CNConsole) {
		mBitmapData	= bm
		mContext	= ctxt
		mConsole	= cons
	}

	public func set(_ xv: JSValue, _ yv: JSValue, _ colv: JSValue) {
		if let x = valueToInt(value: xv), let y = valueToInt(value: yv), let col = valueToColor(value: colv) {
			mBitmapData.set(x: x, y: y, color: col)
		}
	}

	public func get(_ xv: JSValue, _ yv: JSValue) -> JSValue {
		if let x = valueToInt(value: xv), let y = valueToInt(value: yv) {
			if let col = mBitmapData.get(x: x, y: y) {
				return JSValue(object: col, in: mContext)
			}
		}
		return JSValue(nullIn: mContext)
	}

	private func valueToInt(value val: JSValue) -> Int? {
		if val.isNumber {
			if let num = val.toNumber() {
				return num.intValue
			}
		}
		return nil
	}

	private func valueToColor(value val: JSValue) -> CNColor? {
		if val.isObject {
			if let col = val.toObject() as? CNColor {
				return col
			}
		}
		return nil
	}
}
