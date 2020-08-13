/**
 * @file	KLApplication.swift
 * @brief	Define KLApplication class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

#if os(OSX)

import CoconutScript
import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation

@objc public protocol KLApplicationProtocol: JSExport {
	var name: JSValue { get }
	var bundleIdentifier: JSValue { get }
	func isRunning() -> JSValue
	func waitUntilExit() -> JSValue
	func terminate()
}

@objc public class KLApplication: NSObject, KLApplicationProtocol
{
	private var mApplication:	CNReceiverApplication	// in CoconutScript framework
	private var mContext:		KEContext

	public init(applicationInfo appinfo: NSRunningApplication, context ctxt: KEContext) {
		mApplication	= CNReceiverApplication(application: appinfo)
		mContext	= ctxt
	}

	public var name: JSValue {
		get {
			if let name = mApplication.name {
				return JSValue(object: name, in: mContext)
			} else {
				return JSValue(nullIn: mContext)
			}
		}
	}

	public var bundleIdentifier: JSValue {
		get {
			if let ident = mApplication.bundleIdentifier {
				return JSValue(object: ident, in: mContext)
			} else {
				return JSValue(nullIn: mContext)
			}
		}
	}

	public func isRunning() -> JSValue {
		return JSValue(bool: checkRunning(), in: mContext)
	}

	private func checkRunning() -> Bool {
		let runs = NSWorkspace.shared.runningApplications
		for run in runs {
			if mApplication.isEqual(application: run) {
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
		if !mApplication.terminate() {
			NSLog("\(#file) [Error] Failed to terminate application")
			if !mApplication.forceTerminate() {
				NSLog("  Force termination ... Succeeded")
			} else {
				NSLog("  Force termination ... Failed")
			}
		}
	}

}

#endif


