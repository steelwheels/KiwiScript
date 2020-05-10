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
	func moveTo(_ x: JSValue, _ y: JSValue) -> JSValue
}

@objc public class KLCurses: NSObject, KLCursesProtocol
{
	private static var	mObject: 	KLCurses? = nil
	private var		mCurses:	CNCurses
	private var 		mContext:	KEContext

	public static func singleton(console cons: CNConsole, context ctxt: KEContext) -> KLCurses {
		if let newobj = KLCurses.mObject {
			return newobj
		} else {
			let newobj = KLCurses(console: cons, context: ctxt)
			KLCurses.mObject = newobj
			return newobj
		}
	}

	private init(console cons: CNConsole, context ctxt: KEContext){
		mCurses  = CNCurses(console: cons)
		mContext = ctxt
	}

	public func start() {
	}

	public func end() {
	}

	public func moveTo(_ x: JSValue, _ y: JSValue) -> JSValue {
		let result: Bool
		if x.isNumber && y.isNumber {
			result = true
		} else {
			result = false
		}
		return JSValue(bool: result, in: mContext)
	}
}

