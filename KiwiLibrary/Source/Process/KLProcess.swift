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
	var isRunning:   JSValue	{ get }
	var didFinished: JSValue	{ get }
	var exitCode:    JSValue	{ get }
	func terminate()
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

	public var isRunning: JSValue {
		get { return JSValue(bool: mProcess.status.isRunning, in: mContext) }
	}

	public var didFinished: JSValue {
		get { return JSValue(bool: mProcess.status.isStopped, in: mContext) }
	}

	public var exitCode: JSValue {
		return JSValue(int32: mProcess.terminationStatus, in: mContext)
	}

	public func terminate() {
		mProcess.terminate()
	}
}

#endif // os(OSX)

