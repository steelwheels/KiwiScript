/**
 * @file	KLCurses.swift
 * @brief	Define KLCurses class
 * @par Copyright
 *   Copyright (C) 2017-2018 Steel Wheels Project
 */

#if os(OSX)

import CoconutData
import CoconutShell
import KiwiEngine
import JavaScriptCore
import Foundation

@objc public protocol KLCursesProtocol: JSExport
{
	func mode(_ value: JSValue)

	func put(_ value: JSValue)

	var visiblePrompt	: JSValue { get set }
	var doBuffering		: JSValue { get set }
	var doEcho		: JSValue { get set }

	var screenWidth		: JSValue { get }
	var screenHeight	: JSValue { get }
	var cursorX		: JSValue { get }
	var cursorY		: JSValue { get }

	func setColor(_ fcol: JSValue, _ bcol: JSValue)
	func moveTo(_ x: JSValue, _ y:JSValue)

	func getKey() -> JSValue
}

@objc public class KLCurses: NSObject, KLCursesProtocol
{
	private var mCurses:	CNCurses
	private var mContext:	KEContext

	public init(context ctxt: KEContext){
		mCurses 	= CNCurses()
		mContext	= ctxt
	}

	public func mode(_ value: JSValue){
		if value.isBoolean {
			if value.toBool() {
				mCurses.setup()	// enable
			} else {
				mCurses.finalize()
			}
		}
	}

	public func put(_ value: JSValue) {
		mCurses.put(string: value.toString())
	}

	public var visiblePrompt: JSValue {
		get {
			let result = mCurses.visiblePrompt
			return JSValue(bool: result, in: mContext)
		}
		set(value){
			if value.isBoolean {
				mCurses.visiblePrompt = value.toBool()
			}
		}
	}

	public var doBuffering: JSValue {
		get {
			let result = mCurses.doBuffering
			return JSValue(bool: result, in: mContext)
		}
		set(value){
			if value.isBoolean {
				mCurses.doBuffering = value.toBool()
			}
		}
	}

	public var doEcho: JSValue {
		get {
			let result = mCurses.doEcho
			return JSValue(bool: result, in: mContext)
		}
		set(value){
			if value.isBoolean {
				mCurses.doEcho = value.toBool()
			}
		}
	}

	public var screenWidth : JSValue {
		get {
			let width = mCurses.screenWidth
			return JSValue(int32: Int32(width), in: mContext)
		}
	}
	public var screenHeight	: JSValue {
		get {
			let height = mCurses.screenHeight
			return JSValue(int32: Int32(height), in: mContext)
		}
	}
	public var cursorX : JSValue {
		get {
			let x = mCurses.cursorX
			return JSValue(int32: Int32(x), in: mContext)
		}
	}

	public var cursorY : JSValue {
		get {
			let y = mCurses.cursorY
			return JSValue(int32: Int32(y), in: mContext)
		}
	}

	public func setColor(_ fval: JSValue, _ bval: JSValue){
		if fval.isNumber && bval.isNumber {
			let fnum = fval.toInt32()
			let bnum = bval.toInt32()
			if let fcol = CNColor(rawValue: fnum), let bcol = CNColor(rawValue: bnum) {
				mCurses.setColor(foregroundColor: fcol, backgroundColor: bcol)
				return
			}
		}
		NSLog("Failed to set color: \(fval.description) \(bval.description)")
	}

	public func moveTo(_ x: JSValue, _ y:JSValue) {
		if x.isNumber && y.isNumber {
			let xval = x.toInt32()
			let yval = y.toInt32()
			mCurses.moveTo(x: Int(xval), y: Int(yval))
		} else {
			NSLog("Invalid parameters")
		}
	}

	public func getKey() -> JSValue {
		if let val = mCurses.getKey() {
			return JSValue(int32: val, in: mContext)
		} else {
			return JSValue(nullIn: mContext)
		}
	}
}


#endif // os(OSX)

