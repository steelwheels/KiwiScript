/**
 * @file	KLProcess.swift
 * @brief	Extend KLProcess class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import JavaScriptCore
import Foundation
import Darwin

@objc public protocol KLProcessProtocol: JSExport
{
	func exit(_ code: JSValue) -> JSValue
}

@objc public class KLProcess: NSObject, KLProcessProtocol
{
	private var mTerminateHandler: (_ code: Int32) -> Int32

	public init(terminateHandler termhdl: @escaping (_ code: Int32) -> Int32){
		mTerminateHandler = termhdl
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
		let retval = mTerminateHandler(code)
		Darwin.exit(retval)
	}
}

