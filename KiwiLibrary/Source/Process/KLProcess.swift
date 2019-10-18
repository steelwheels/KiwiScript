/**
 * @file	KLProcess.swift
 * @brief	Define KLProcess class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation

@objc public protocol KLProcessProtocol: JSExport {
	func isRunning() -> Bool
	func waitUntilExit() -> Int32
}

#if os(OSX)

@objc public class KLProcess: NSObject, KLProcessProtocol
{
	private var mProcess:	CNProcess
	private var mContext:	KEContext

	public init(process proc: CNProcess, context ctxt: KEContext){
		mProcess = proc
		mContext = ctxt
	}

	public func isRunning() -> Bool {
		var result: Bool
		switch mProcess.status {
		case .Idle:	result = false
		case .Running:	result = true
		case .Finished:	result = false
		}
		return result
	}

	public func waitUntilExit() -> Int32 {
		return mProcess.waitUntilExit()
	}
}

#endif // os(OSX)

