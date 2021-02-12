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
	var width:  JSValue { get }
	var height: JSValue { get }

	func set(_ x: JSValue, _ y: JSValue ,_ col: JSValue)
	func get(_ x: JSValue, _ y: JSValue) -> JSValue
}

@objc public class KLBitmapData: NSObject, KLBitmapDataProtocol
{
	private var mBitmapData:	CNBitmapData
	private var mContext:		KEContext

	public init(bitmapdata data: CNBitmapData, context ctxt: KEContext){
		mBitmapData	= data
		mContext	= ctxt
	}

	public var width: JSValue {
		get { return JSValue(int32: Int32(mBitmapData.width), in: mContext) }
	}

	public var height: JSValue {
		get { return JSValue(int32: Int32(mBitmapData.height), in: mContext) }
	}

	public func set(_ x: JSValue, _ y: JSValue ,_ col: JSValue) {
		if x.isNumber && y.isNumber && col.isObject {
			let xv = x.toInt32()
			let yv = y.toInt32()
			if let c = col.toObject() as? CNColor {
				mBitmapData.set(x: Int(xv), y: Int(yv), color: c)
			}
		}
	}

	public func get(_ x: JSValue, _ y: JSValue) -> JSValue {
		if x.isNumber && y.isNumber {
			let xv = x.toInt32()
			let yv = y.toInt32()
			if let col = mBitmapData.get(x: Int(xv), y: Int(yv)) {
				return JSValue(object: col, in: mContext)
			}
		}
		return JSValue(nullIn: mContext)
	}

}


