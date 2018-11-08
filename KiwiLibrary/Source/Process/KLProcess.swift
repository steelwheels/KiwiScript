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

#if os(OSX)

@objc public protocol KLProcessProtocol: JSExport
{
	func isRunning() -> JSValue // Bool
	func waitUntilExit() -> JSValue // Undefined
}

@objc public class KLProcess: NSObject, KLProcessProtocol
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


