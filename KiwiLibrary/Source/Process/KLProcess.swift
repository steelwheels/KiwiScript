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
	func exit(_ code: JSValue) -> JSValue 		// Undefined
}

@objc public protocol KLProcessObjectProtocol: JSExport
{
	func isRunning() -> JSValue // Bool
	func waitUntilExit() -> JSValue // Undefined
}

@objc public class KLProcess: NSObject, KLProcessProtocol
{
	private var mContext:	KEContext
	private var mConfig: 	KLConfig

	public init(context ctxt: KEContext, config conf: KLConfig){
		mContext = ctxt
		mConfig  = conf
		super.init()
	}

	public func exit(_ code: JSValue) -> JSValue {
		let ecode: Int32
		if code.isNumber {
			ecode = code.toInt32()
		} else {
			NSLog("[Error] Invalid parameter: \(code.description) at \(#function)")
			ecode = 1
		}
		switch mConfig.kind {
		case .Terminal:
			Darwin.exit(ecode)
		case .Window:
			NSApplication.shared.terminate(self)
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


