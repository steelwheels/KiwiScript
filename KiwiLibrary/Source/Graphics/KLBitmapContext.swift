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

	func set(_ xval: JSValue, _ yval: JSValue, _ colval: JSValue)
	func clear()
	func get(_ xval: JSValue, _ yval: JSValue) -> JSValue
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

	public func set(_ xval: JSValue, _ yval: JSValue, _ colval: JSValue) {
		if xval.isNumber && yval.isNumber && colval.isObject {
			let x = Int(xval.toInt32())
			let y = Int(yval.toInt32())
			if let col = colval.toObject() as? CNColor {
				mBContext.set(x: x, y: y, color: col)
			} else if let cols = colval.toObject() as? Array<Array<CNColor>> {
				mBContext.set(x: x, y: y, bitmap: cols)
			} else if let cols = colval.toObject() as? Array<Array<Int>> {
				let fcol = CNPreference.shared.viewPreference.foregroundColor
				let bcol = CNPreference.shared.viewPreference.backgroundColor
				var newcols: Array<Array<CNColor>> = []
				for col in cols {
					var newrow: Array<CNColor> = []
					for pix in col {
						let newpix = pix != 0 ? fcol : bcol
						newrow.append(newpix)
					}
					newcols.append(newrow)
				}
				mBContext.set(x: x, y: y, bitmap: newcols)
			} else {
				mConsole.error(string: "[Error] Invalid color parameter: \(String(describing: colval.toString()))\n")
			}
		} else {
			mConsole.error(string: "[Error] Invalid parameter at \(#file)\n")
		}
	}

	public func clear() {
		mBContext.clear()
	}

	public func get(_ xval: JSValue, _ yval: JSValue) -> JSValue {
		if xval.isNumber && yval.isNumber {
			let x = Int(xval.toInt32())
			let y = Int(yval.toInt32())
			if let col = mBContext.get(x: x, y: y) {
				return JSValue(object: col, in: mJContext)
			}
		}
		return JSValue(nullIn: mJContext)
	}
}


