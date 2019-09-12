/**
 * @file	KLProcess.swift
 * @brief	Define KLProcess class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

@objc public class KLThread: NSObject, KLProcessProtocol
{
	private var mThread:	CNThread
	private var mContext:	KEContext

	public init(thread thrd: CNThread, context ctxt: KEContext){
		mThread  = thrd
		mContext = ctxt
	}

	public func isRunning() -> Bool {
		var result: Bool
		switch mThread.status {
		case .Idle:	result = false
		case .Running:	result = true
		case .Finished:	result = false
		}
		return result
	}

	public func waitUntilExit() {
		mThread.waitUntilExit()
	}
}


