/**
 * @file	KLProcess.swift
 * @brief	Extend KLProcess class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import KiwiEngine
import JavaScriptCore
import Foundation
import Darwin

@objc public protocol KLProcessProtocol: JSExport
{
	func exit(_ code: JSValue) -> JSValue
	func sleep(_ time: JSValue) -> JSValue
}

@objc public class KLProcess: NSObject, KLProcessProtocol
{
	private var mContext: 		KEContext
	private var mExceptionHandler:	(_ exception: KEException) -> Void

	public init(context ctxt: KEContext, exceptionHandler ehandler: @escaping (_ exception: KEException) -> Void){
		mContext	  = ctxt
		mExceptionHandler = ehandler
	}

	public func exit(_ cval: JSValue) -> JSValue
	{
		let code: Int32
		if cval.isNumber {
			code = cval.toInt32()
		} else {
			NSLog("Unknown code value")
			code = 1
		}
		mExceptionHandler(.Exit(code))
		Darwin.exit(code)
	}

	public func sleep(_ time: JSValue) -> JSValue
	{
		if time.isNumber {
			let tval = time.toDouble()
			Thread.sleep(forTimeInterval: TimeInterval(tval))
		} else {
			NSLog("Invalid value to sleep")
		}
		return JSValue(undefinedIn: mContext)
	}
}

