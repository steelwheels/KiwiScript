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

	var logicalSize: JSValue { get }

	func setColor(_ val: JSValue)

	func drawPoint(_ x: JSValue, _ y: JSValue)
	func drawRect(_ x: JSValue, _ y: JSValue, _ width: JSValue, _ height: JSValue)
}

@objc public class KLBitmapContext: NSObject, KLBitmapContextProtocol
{
	public typealias Color = CNColor.CursesColor

	private var mBContext:	CNBitmapContext
	private var mJContext:	KEContext
	private var mConsole:	CNConsole

	public init(bitmapContext bctxt: CNBitmapContext, scriptContext sctxt: KEContext, console cons: CNConsole) {
		mBContext	= bctxt
		mJContext	= sctxt
		mConsole 	= cons
		super.init()
	}

	public var black: 	JSValue { get { return JSValue(int32: Int32(Color.black.rawValue),	in: mJContext) }}
	public var red:		JSValue { get { return JSValue(int32: Int32(Color.red.rawValue),	in: mJContext) }}
	public var green:	JSValue { get { return JSValue(int32: Int32(Color.green.rawValue),	in: mJContext) }}
	public var yellow:	JSValue { get { return JSValue(int32: Int32(Color.yellow.rawValue),	in: mJContext) }}
	public var blue:	JSValue { get { return JSValue(int32: Int32(Color.blue.rawValue),	in: mJContext) }}
	public var magenta:	JSValue { get { return JSValue(int32: Int32(Color.magenta.rawValue),	in: mJContext) }}
	public var cyan:	JSValue { get { return JSValue(int32: Int32(Color.cyan.rawValue),	in: mJContext) }}
	public var white: 	JSValue { get { return JSValue(int32: Int32(Color.white.rawValue),	in: mJContext) }}

	public var logicalSize: JSValue {
		get {
			return JSValue(size: mBContext.logicalSize, in: mJContext)
		}
	}

	public func setColor(_ val: JSValue) {
		if let col = valueToColor(value: val) {
			mBContext.set(color: col)
		} else {
			mConsole.error(string: "Invalid parameter at \(#function)\n")
		}
	}

	public func drawPoint(_ xv: JSValue, _ yv: JSValue) {
		if let x = valueToInt(value: xv), let y = valueToInt(value: yv) {
			mBContext.drawPoint(x: x, y: y)
		} else {
			mConsole.error(string: "Invalid parameter at \(#function)\n")
		}
	}

	public func drawRect(_ xv: JSValue, _ yv: JSValue, _ widthv: JSValue, _ heightv: JSValue) {
		if let x = valueToInt(value: xv), let y = valueToInt(value: yv), let width = valueToInt(value: widthv), let height = valueToInt(value: heightv) {
			mBContext.drawRect(x: x, y: y, width: width, height: height)
		} else {
			mConsole.error(string: "Invalid parameter at \(#function)\n")
		}
	}

	private func valueToInt(value val: JSValue) -> Int? {
		if val.isNumber {
			if let num = val.toNumber() {
				return num.intValue
			}
		}
		return nil
	}

	private func valueToColor(value val: JSValue) -> Color? {
		if val.isNumber {
			if let num = val.toNumber() {
				if let col = Color(rawValue: num.intValue) {
					return col
				}
			}
		}
		return nil
	}
}

