/**
 * @file	KLApplication.swift
 * @brief	Define KLApplication class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation

#if os(OSX)

@objc public protocol KLApplicationProtocol: JSExport {
	func name() -> JSValue
	func isRunning() -> JSValue
	func waitUntilExit() -> JSValue
	func terminate()
}

@objc public class KLApplication: NSObject, KLApplicationProtocol
{
	private var mApplicationInfo:	NSRunningApplication
	private var mContext:		KEContext

	public init(applicationInfo appinfo: NSRunningApplication, context ctxt: KEContext) {
		mApplicationInfo = appinfo
		mContext	 = ctxt
	}

	public func name() -> JSValue {
		if let name = mApplicationInfo.localizedName {
			return JSValue(object: name, in: mContext)
		} else {
			return JSValue(nullIn: mContext)
		}
	}

	public func isRunning() -> JSValue {
		return JSValue(bool: checkRunning(), in: mContext)
	}

	private func checkRunning() -> Bool {
		let runs = NSWorkspace.shared.runningApplications
		for run in runs {
			if mApplicationInfo.isEqual(run) {
				return true
			}
		}
		return false
	}

	public func waitUntilExit() -> JSValue {
		while self.checkRunning() {
			Thread.sleep(forTimeInterval: 0.1)
		}
		return JSValue(int32: 0, in: mContext)
	}

	public func terminate() {
		if !mApplicationInfo.terminate() {
			NSLog("\(#file) [Error] Failed to terminate application")
			if !mApplicationInfo.forceTerminate() {
				NSLog("  Force termination ... Succeeded")
			} else {
				NSLog("  Force termination ... Failed")
			}
		}
	}

}

#endif


