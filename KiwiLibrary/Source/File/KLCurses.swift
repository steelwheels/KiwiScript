/**
 * @file	KLCurses.swift
 * @brief	Extend KLCurses class
 * @par Copyright
 *   Copyright (C) 2017-2018 Steel Wheels Project
 */

import Canary
import KiwiEngine
import JavaScriptCore
import Foundation

@objc public protocol KLCursesProtocol: JSExport
{
	func setup(_ visiblePrompt: JSValue, _ bufferMode: JSValue) -> JSValue
	func log(_ value: JSValue)
}

@objc public class KLCurses: NSObject, KLCursesProtocol
{
	private var mContext: KEContext
	private var mCurses:  CNCurses

	public init(context ctxt: KEContext){
		mContext = ctxt
		mCurses  = CNCurses()
	}

	public func setup(_ visiblePrompt: JSValue, _ bufferMode: JSValue) -> JSValue {
		let result: Bool
		if visiblePrompt.isBoolean && bufferMode.isBoolean {
			let visprom = visiblePrompt.toBool()
			let bufmode = bufferMode.toBool()
			mCurses.setup(visiblePrompt: visprom, bufferMode: bufmode)
			result = true
		} else {
			NSLog("Setup failed")
			result = false
		}
		return JSValue(bool: result, in: mContext)
	}

	public func log(_ value: JSValue){
		if let str = value.toString() {
			mCurses.put(string: str)
		} else {
			NSLog("Logging failed: \(value.description)")
		}
	}
}
