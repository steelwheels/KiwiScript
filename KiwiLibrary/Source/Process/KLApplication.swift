/**
 * @file	KLApplication.swift
 * @brief	Define KLApplication class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

#if os(OSX)

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
	func activate() -> JSValue
	func makeNewDocument() -> JSValue
	func open(_ val: JSValue) -> JSValue
	func setNameOfFrontWindow(_ val: JSValue) -> JSValue
	func nameOfFrontWindow() -> JSValue
	func setContentOfFrontWindow(_ val: JSValue) -> JSValue
	func contentOfFrontWindow() -> JSValue
	func save(_ val: JSValue) -> JSValue
}

@objc public class KLApplication: NSObject, KLApplicationProtocol
{
	private var mApplication:	CNRemoteApplication
	private var mContext:		KEContext

	public init(applicationInfo appinfo: NSRunningApplication, context ctxt: KEContext) {
		mApplication	= CNRemoteApplication(application: appinfo)
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

	public func activate() -> JSValue {
		let result: Bool
		if let _ = mApplication.activate() {
			result = false // some error
		} else {
			result = true  // no error
		}
		return JSValue(bool: result, in: mContext)
	}

	public func makeNewDocument() -> JSValue {
		let result: Bool
		if let _ = mApplication.makeNewDocument() {
			result = false // some error
		} else {
			result = true  // no error
		}
		return JSValue(bool: result, in: mContext)
	}

	public func open(_ val: JSValue) -> JSValue {
		guard let url = valueToURL(value: val) else {
			return JSValue(bool: false, in: mContext)
		}
		if let _ = mApplication.open(fileURL: url) {
			/* Some errors */
			return JSValue(bool: false, in: mContext)
		} else {
			/* No error */
			return JSValue(bool: true, in: mContext)
		}
	}

	public func setNameOfFrontWindow(_ val: JSValue) -> JSValue {
		let result: Bool
		if let str = val.toString() {
			if let _ = mApplication.setNameOfFrontWindow(name: str) {
				result = false 	// some errors
			} else {
				result = true
			}
		} else {
			result = false
		}
		return JSValue(bool: result, in: mContext)
	}

	public func nameOfFrontWindow() -> JSValue {
		let result: JSValue
		switch mApplication.nameOfFrontWindow() {
		case .ok(let str):
			result = JSValue(object: str, in: mContext)
		case .error(_):
			result = JSValue(nullIn: mContext)
		}
		return result
	}

	public func setContentOfFrontWindow(_ val: JSValue) -> JSValue {
		let result: Bool
		if let str = val.toString() {
			if let _ = mApplication.setContentOfFrontWindow(context: str) {
				result = false 	// some errors
			} else {
				result = true
			}
		} else {
			result = false
		}
		return JSValue(bool: result, in: mContext)
	}

	public func contentOfFrontWindow() -> JSValue {
		let result: JSValue
		switch mApplication.contentOfFrontWindow() {
		case .ok(let str):
			result = JSValue(object: str, in: mContext)
		case .error(_):
			result = JSValue(nullIn: mContext)
		}
		return result
	}

	public func save(_ val: JSValue) -> JSValue {
		guard let url = valueToURL(value: val) else {
			return JSValue(bool: false, in: mContext)
		}
		if let _ = mApplication.save(fileURL: url) {
			/* Some errors */
			return JSValue(bool: false, in: mContext)
		} else {
			/* No error */
			return JSValue(bool: true, in: mContext)
		}
	}

	private func valueToURL(value val: JSValue) -> URL? {
		let url: URL?
		if val.isURL {
			url = val.toURL()
		} else if val.isString {
			url = URL(fileURLWithPath: val.toString())
		} else {
			url = nil
		}
		return url
	}
}

#endif


