/**
 * @file	KLProcess.swift
 * @brief	Extend KLProcess class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

#if os(OSX)

import KiwiEngine
import JavaScriptCore
import Foundation
import Darwin

@objc public protocol KLProcessProtocol: JSExport
{
	func exit(_ code: JSValue) -> JSValue
	func sleep(_ time: JSValue) -> JSValue
}

@objc public protocol KLProcessObjectProtocol: JSExport
{
	func isRunning() -> JSValue // Bool
	func waitUntilExit() -> JSValue // Undefined
}

@objc public class KLProcess: NSObject, KLProcessProtocol
{
	private var mContext: 		KEContext

	public init(context ctxt: KEContext){
		mContext	  = ctxt
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
		
		let callback = mContext.exceptionCallback
		let except = KEException.Exit(code)
		callback(except)

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

@objc public class KLProcessObject: NSObject, KLProcessObjectProtocol
{
	private var mProcess:		Process
	private var mContext:		KEContext

	public init(process proc: Process, context ctxt: KEContext){
		mProcess	= proc
		mContext	= ctxt
	}

	public func isRunning() -> JSValue {
		return JSValue(bool: mProcess.isRunning, in: mContext)
	}

	public func waitUntilExit() -> JSValue {
		mProcess.waitUntilExit()
		return JSValue(undefinedIn: mContext)
	}
}

#endif // os(OSX)

