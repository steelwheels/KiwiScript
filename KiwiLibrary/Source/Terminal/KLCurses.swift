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

	var columns: JSValue { get }
	var lines:   JSValue { get }

	func moveTo(_ x: JSValue, _ y: JSValue) -> JSValue
}

@objc public class KLCurses: NSObject, KLCursesProtocol
{
	private var		mCurses:	CNCurses
	private var 		mContext:	KEContext

	public init(console cons: CNConsole, environment env: CNEnvironment, context ctxt: KEContext){
		mCurses  = CNCurses(console: cons, environment: env)
		mContext = ctxt
	}

	public func start() {
		mCurses.start()
	}

	public func end() {
		mCurses.end()
	}

	public var columns: JSValue {
		get { return JSValue(int32: Int32(mCurses.columns), in: mContext) }
	}

	public var lines:   JSValue {
		get { return JSValue(int32: Int32(mCurses.lines), in: mContext) }
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
}

