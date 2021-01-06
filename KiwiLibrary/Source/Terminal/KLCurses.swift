/**
 * @file   KLCurses.swift
 * @brief  Define KLCurses class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

@objc public protocol KLCursesProtocol: JSExport
{
	func start()
	func end()

	var width:  JSValue { get }
	var height: JSValue { get }

	var foregroundColor: JSValue { get set }
	var backgroundColor: JSValue { get set }

	func moveTo(_ x: JSValue, _ y: JSValue) -> JSValue
	func inkey() -> JSValue

	func put(_ str: JSValue)
	func fill(_ x: JSValue, _ y: JSValue, _ width: JSValue, _ height: JSValue, _ c: JSValue)
}

@objc public class KLCurses: NSObject, KLCursesProtocol
{
	private var	mCurses:	CNCurses
	private var 	mContext:	KEContext


	public init(console cons: CNFileConsole, terminalInfo terminfo: CNTerminalInfo, context ctxt: KEContext){
		mCurses  = CNCurses(console: cons, terminalInfo: terminfo)
		mContext = ctxt
	}

	public func start() {
		mCurses.start()
	}

	public func end() {
		mCurses.end()
	}

	public var width: JSValue {
		get { return JSValue(int32: Int32(mCurses.width), in: mContext) }
	}

	public var height:   JSValue {
		get { return JSValue(int32: Int32(mCurses.height), in: mContext) }
	}

	public var foregroundColor: JSValue {
		get {
			let colid = mCurses.foregroundColor.escapeCode()
			return JSValue(int32: colid, in: mContext)
		}
		set(newcol) {
			if newcol.isNumber {
				if let col = CNColor.color(withEscapeCode: newcol.toInt32()) {
					mCurses.foregroundColor = col
				}
			}
		}
	}

	public var backgroundColor: JSValue {
		get {
			let colid = mCurses.backgroundColor.escapeCode()
			return JSValue(int32: colid, in: mContext)
		}
		set(newcol) {
			if newcol.isNumber {
				if let col = CNColor.color(withEscapeCode: newcol.toInt32()) {
					mCurses.backgroundColor = col
				}
			}
		}
	}

	public func moveTo(_ x: JSValue, _ y: JSValue) -> JSValue {
		let result: Bool
		if x.isNumber && y.isNumber {
			mCurses.moveTo(x: Int(x.toInt32()), y: Int(y.toInt32()))
			result = true
		} else {
			result = false
		}
		return JSValue(bool: result, in: mContext)
	}

	public func inkey() -> JSValue {
		if let c = mCurses.inkey() {
			return JSValue(object: String(c), in: mContext)
		} else {
			return JSValue(nullIn: mContext)
		}
	}

	public func put(_ str: JSValue) {
		if let s = str.toString() {
			mCurses.put(string: s)
		} else {
			NSLog("Failed to put string")
		}
	}

	public func fill(_ x: JSValue, _ y: JSValue, _ width: JSValue, _ height: JSValue, _ c: JSValue) {
		if x.isNumber && y.isNumber && width.isNumber && height.isNumber && c.isString {
			if let str = c.toString() {
				if let cv = str.first {
					let xv = Int(x.toInt32())
					let yv = Int(y.toInt32())
					let wv = Int(width.toInt32())
					let hv = Int(height.toInt32())
					mCurses.fill(x: xv, y: yv, width: wv, height: hv, char: cv)
				}
			}
		}
	}
}

