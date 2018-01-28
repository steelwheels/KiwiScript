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
	private var mExceptionHandler: (_ exception: KLException) -> Void

	public init(exceptionHandler ehandler: @escaping (_ exception: KLException) -> Void){
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
}

