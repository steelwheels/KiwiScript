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
import AppKit
import Foundation

@objc public protocol KLApplicationProtocol: JSExport {
	var name: JSValue { get }
	var bundleIdentifier: JSValue { get }
	func isRunning() -> JSValue
	func waitUntilExit() -> JSValue
	func terminate()
	func activate() -> JSValue
}

@objc public protocol KLTextEditApplicationProtocol: JSExport
{
	func makeNewDocument() -> JSValue
	func open(_ val: JSValue) -> JSValue
	func close(_ val: JSValue) -> JSValue
	func setNameOfFrontWindow(_ val: JSValue) -> JSValue
	func nameOfFrontWindow() -> JSValue
	func setContentOfFrontWindow(_ val: JSValue) -> JSValue
	func contentOfFrontWindow() -> JSValue
	func save(_ val: JSValue) -> JSValue
}

@objc public protocol KLSafariApplicationProtocol: JSExport
{
	func open(_ val: JSValue) -> JSValue
}

@objc public class KLApplication: NSObject, KLApplicationProtocol
{
	private var mApplication:	CNEventReceiverApplication
	private var mContext:		KEContext

	public var context: KEContext { get { return mContext }}

	public init(application app: CNEventReceiverApplication, context ctxt: KEContext) {
		mApplication	= app
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
			CNLog(logLevel: .error, message: "Application: failed to terminate")
			let _ = mApplication.forceTerminate()
		}
	}

	public func activate() -> JSValue {
		let result: Bool
		switch mApplication.activate() {
		case .ok(_):
			result = true
		case .error(let err):
			CNLog(logLevel: .error, message: "AppleEventError activate: \(err.toString())")
			result = false
		@unknown default:
			CNLog(logLevel: .error, message: "AppleEventError activate: <unknown>")
			result = false
		}
		return JSValue(bool: result, in: mContext)
	}

	public func valueToURL(value val: JSValue) -> URL? {
		var url: URL? = nil
		if val.isURL {
			url = val.toURL()
		} else if val.isString {
			if let str = val.toString() {
				if let _ = FileManager.default.schemeInPath(pathString: str) {
					/* URL based on given scheme */
					url = URL(string: str)
				} else {
					/* File URL */
					url = URL(fileURLWithPath: str)
				}
			}
		}
		return url
	}
}

@objc public class KLTextEditApplication: KLApplication, KLTextEditApplicationProtocol
{
	private var mApplication:	CNTextEditApplication

	public init(textEditApplication app: CNTextEditApplication, context ctxt: KEContext) {
		mApplication = app
		super.init(application: app, context: ctxt)
	}

	public func makeNewDocument() -> JSValue {
		let result: Bool
		switch mApplication.makeNewDocument() {
		case .ok(_):
			result = true
		case .error(let err):
			CNLog(logLevel: .error, message: "AppleEventError makeNewDocument: \(err.toString())")
			result = false
		@unknown default:
			CNLog(logLevel: .error, message: "AppleEventError makeNewDocument: <unknown>")
			result = false
		}
		return JSValue(bool: result, in: context)
	}

	public func open(_ val: JSValue) -> JSValue {
		guard let url = valueToURL(value: val) else {
			return JSValue(bool: false, in: context)
		}
		let result: Bool
		switch mApplication.open(fileURL: url) {
		case .ok(_):
			result = true

		case .error(let err):
			CNLog(logLevel: .error, message: "AppleEventError open: \(err.toString())")
			result = false
		@unknown default:
			CNLog(logLevel: .error, message: "AppleEventError open: <unknown>")
			result = false
		}
		return JSValue(bool: result, in: context)
	}

	public func close(_ val: JSValue) -> JSValue {
		let fileurl: URL?
		if !val.isNull {
			if let url = valueToURL(value: val) {
				fileurl = url
			} else {
				return JSValue(bool: false, in: context)
			}
		} else {
			fileurl = nil
		}
		let result: Bool
		switch mApplication.close(fileURL: fileurl) {
		case .ok(_):
			result = true
		case .error(let err):
			CNLog(logLevel: .error, message: "AppleEvent close: \(err.toString())")
			result = false
		@unknown default:
			CNLog(logLevel: .error, message: "AppleEvent close: <unknown>")
			result = false
		}
		return JSValue(bool: result, in: context)
	}

	public func setNameOfFrontWindow(_ val: JSValue) -> JSValue {
		let result: Bool
		if let str = val.toString() {
			switch  mApplication.setNameOfFrontWindow(name: str) {
			case .ok(_):
				result = true
			case .error(let err):
				CNLog(logLevel: .error, message: "AppleEvent setNameOfFrontWindow: \(err.toString())")
				result = false
			@unknown default:
				CNLog(logLevel: .error, message: "AppleEvent close: <unknown>")
				result = false
			}
		} else {
			result = false
		}
		return JSValue(bool: result, in: context)
	}

	public func nameOfFrontWindow() -> JSValue {
		let result: JSValue
		switch mApplication.nameOfFrontWindow() {
		case .ok(let str):
			result = JSValue(object: str, in: context)
		case .error(let err):
			CNLog(logLevel: .error, message: "AppleEventError nameOfFrontWindow: \(err.toString())")
			result = JSValue(nullIn: context)
		@unknown default:
			CNLog(logLevel: .error, message: "AppleEventError nameOfFrontWindow: <unknown>")
			result = JSValue(nullIn: context)
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
		return JSValue(bool: result, in: context)
	}

	public func contentOfFrontWindow() -> JSValue {
		let result: JSValue
		switch mApplication.contentOfFrontWindow() {
		case .ok(let str):
			result = JSValue(object: str, in: context)
		case .error(let err):
			CNLog(logLevel: .error, message: "AppleEventError contentOfFrontWindow: \(err.toString())")
			result = JSValue(nullIn: context)
		@unknown default:
			CNLog(logLevel: .error, message: "AppleEventError contentOfFrontWindow: <unknown>")
			result = JSValue(nullIn: context)
		}
		return result
	}

	public func save(_ val: JSValue) -> JSValue {
		guard let url = valueToURL(value: val) else {
			return JSValue(bool: false, in: context)
		}
		let result: Bool
		switch mApplication.save(fileURL: url) {
		case .ok(_):
			result = true
		case .error(let err):
			CNLog(logLevel: .error, message: "AppleEventError save: \(err.toString())")
			result = false
		@unknown default:
			CNLog(logLevel: .error, message: "AppleEventError save: <unknown>")
			result = false
		}
		return JSValue(bool: result, in: context)
	}
}

@objc public class KLSafariApplication: KLApplication, KLSafariApplicationProtocol
{
	private var mApplication:	CNSafariApplication

	public init(safariApplication app: CNSafariApplication, context ctxt: KEContext) {
		mApplication = app
		super.init(application: app, context: ctxt)
	}

	public func open(_ val: JSValue) -> JSValue {
		guard let url = valueToURL(value: val) else {
			return JSValue(bool: false, in: context)
		}
		let result: Bool
		switch mApplication.open(fileURL: url) {
		case .ok(_):
			result = true
		case .error(let err):
			CNLog(logLevel: .error, message: "AppleEventError open: \(err.toString())")
			result = false
		@unknown default:
			CNLog(logLevel: .error, message: "AppleEventError open: <unknown>")
			result = false
		}
		return JSValue(bool: result, in: context)
	}
}

#endif


