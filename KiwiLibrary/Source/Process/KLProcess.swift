/**
 * @file	KLProcess.swift
 * @brief	Define KLProcess class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

#if os(OSX)

import KiwiEngine
import JavaScriptCore
import Foundation

@objc public protocol KLProcessProtocol: JSExport {
	func isRunning() -> Bool
	func waitUntilExit()
}

@objc public class KLProcess: NSObject, KLProcessProtocol
{
	private var mProcess:	Process
	private var mContext:	KEContext

	public init(process proc: Process, context ctxt: KEContext){
		mProcess = proc
		mContext = ctxt
	}

	public func isRunning() -> Bool {
		return mProcess.isRunning
	}

	public func waitUntilExit() {
		mProcess.waitUntilExit()
	}
}

#endif // os(OSX)

