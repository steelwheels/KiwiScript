/**
 * @file	KLBitmapContext.swift
 * @brief	Define KLBitmapContext class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation

@objc public protocol KLBitmapContextProtocol: JSExport
{
	var black:	JSValue { get }
	var red:	JSValue { get }
	var green:	JSValue { get }
	var yellow:	JSValue { get }
	var blue:	JSValue { get }
	var magenta:	JSValue { get }
	var cyan:	JSValue { get }
	var white:	JSValue { get }

	var width:      JSValue { get }
	var height:     JSValue { get }
	var baseBitmap: JSValue { get }

	func draw(_ bitmap: JSValue)
}

@objc public protocol KLBitmapDataProtocol: JSExport
{
	func set(_ x: JSValue, _ y: JSValue, _ col: JSValue)
	func get(_ x: JSValue, _ y: JSValue) -> JSValue
}

@objc public class KLBitmapContext: NSObject, KLBitmapContextProtocol
{
	private var mBContext:	CNBitmapContext
	private var mJContext:	KEContext
	private var mConsole:	CNConsole

	public init(bitmapContext bctxt: CNBitmapContext, scriptContext sctxt: KEContext, console cons: CNConsole) {
		mBContext	= bctxt
		mJContext	= sctxt
		mConsole 	= cons
		super.init()
	}

	public var black: 	JSValue { get { return JSValue(object: CNColor.black,	in: mJContext) }}
	public var red:		JSValue { get { return JSValue(object: CNColor.red,	in: mJContext) }}
	public var green:	JSValue { get { return JSValue(object: CNColor.green,	in: mJContext) }}
	public var yellow:	JSValue { get { return JSValue(object: CNColor.yellow,	in: mJContext) }}
	public var blue:	JSValue { get { return JSValue(object: CNColor.blue,	in: mJContext) }}
	public var magenta:	JSValue { get { return JSValue(object: CNColor.magenta,	in: mJContext) }}
	public var cyan:	JSValue { get { return JSValue(object: CNColor.cyan,	in: mJContext) }}
	public var white: 	JSValue { get { return JSValue(object: CNColor.white,	in: mJContext) }}

	public var width:      JSValue { get { return JSValue(int32: Int32(mBContext.width),  in: mJContext) }}
	public var height:     JSValue { get { return JSValue(int32: Int32(mBContext.height), in: mJContext) }}
	public var baseBitmap: JSValue { get {
		let baseobj = KLBitmapData(bitmap: mBContext.baseBitmap, context: mJContext, console: mConsole)
		return JSValue(object: baseobj, in: mJContext)
	}}

	public func draw(_ val: JSValue) {
		if val.isObject {
			if let bm = val.toObject() as? KLBitmapData {
				mBContext.draw(bitmap: bm.data)
				return
			}
		}
		mConsole.error(string: "Bitmap object is required but \(val) is given\n")
	}
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

