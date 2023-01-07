/**
 * @file	KLPreference.swift
 * @brief	Define KLPreference class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

public extension CNPreferenceTable
{
	func set(scriptValue val: JSValue, forKey key: String) {
		set(objectValue: val, forKey: key)
	}

	func scriptValue(forKey key: String) -> JSValue? {
		if let val = objectValue(forKey: key) as? JSValue {
			return val
		} else {
			return nil
		}
	}
}

@objc public protocol KLPreferenceProtocol: JSExport
{
	var system:		JSValue { get }
	var terminal:		JSValue { get }
	var user:		JSValue { get }
}

@objc open class KLPreference: NSObject, KLPreferenceProtocol
{
	private var mContext: KEContext

	public var context: KEContext { get { return mContext }}

	public init(context ctxt: KEContext){
		mContext = ctxt
	}

	public var system: JSValue { get {
		let pref = KLSystemPreference(context: mContext)
		return JSValue(object: pref, in: mContext)
	}}

	public var terminal: JSValue { get {
		let pref = KLTerminalPreference(context: mContext)
		return JSValue(object: pref, in: mContext)
	}}

	public var user: JSValue { get {
		let pref = KLUserPreference(context: mContext)
		return JSValue(object: pref, in: mContext)
	}}
}

@objc public protocol KLSystemPreferenceProtocol: JSExport
{
	var device	: JSValue { get }
	var version	: JSValue { get }
	var logLevel	: JSValue { get set }
}

@objc public class KLSystemPreference: NSObject, KLSystemPreferenceProtocol
{
	private var mContext: KEContext

	public init(context ctxt: KEContext){
		mContext = ctxt
	}

	public var device: JSValue { get {
		let syspref = CNPreference.shared.systemPreference
		let devnum  = syspref.device.rawValue
		return JSValue(object: NSNumber(integerLiteral: devnum), in: mContext)
	}}
		
	public var version: JSValue { get {
		let syspref = CNPreference.shared.systemPreference
		let verstr  = syspref.version
		return JSValue(object: verstr, in: mContext)
	}}

	public var logLevel: JSValue {
		get {
			let curlevel = CNPreference.shared.systemPreference.logLevel
			return JSValue(int32: Int32(curlevel.rawValue), in: mContext)
		}
		set(newval) {
			if newval.isNumber {
				let ival = newval.toInt32()
				if let level = CNConfig.LogLevel(rawValue: Int(ival)) {
					CNPreference.shared.systemPreference.logLevel = level
					return // without error
				}
			}
			CNLog(logLevel: .error, message: "Invalid logLevel value: \(newval.description)", atFunction: #function, inFile: #file)
		}
	}
}

@objc public protocol KLTerminalPreferenceProtocol: JSExport
{
	var width:  JSValue { get set }
	var height: JSValue { get set }
	var foregroundColor: JSValue { get set }
	var backgroundColor: JSValue { get set }
}

@objc public class KLTerminalPreference: NSObject, KLTerminalPreferenceProtocol
{
	private var mContext: KEContext

	public init(context ctxt: KEContext){
		mContext = ctxt
	}

	public var width: JSValue {
		get {
			let pref  = CNPreference.shared.terminalPreference
			return JSValue(int32: Int32(pref.width), in: mContext)
		}
		set(newval) {
			if newval.isNumber {
				let pref     = CNPreference.shared.terminalPreference
				let newwidth = newval.toInt32()
				pref.width   = Int(newwidth)
			}
		}
	}

	public var height: JSValue {
		get {
			let pref  = CNPreference.shared.terminalPreference
			return JSValue(int32: Int32(pref.height), in: mContext)
		}
		set(newval) {
			if newval.isNumber {
				let pref      = CNPreference.shared.terminalPreference
				let newheight = newval.toInt32()
				pref.height   = Int(newheight)
			}
		}
	}

	public var foregroundColor: JSValue {
		get {
			let pref  = CNPreference.shared.terminalPreference
			let color = pref.foregroundTextColor
			return JSValue(int32: color.escapeCode(), in: mContext)
		}
		set(newval) {
			if newval.isNumber {
				if let col = CNColor.color(withEscapeCode: newval.toInt32()) {
					let pref = CNPreference.shared.terminalPreference
					pref.foregroundTextColor = col
					return
				}
			}
			CNLog(logLevel: .error, message: "Failed to set foregound color", atFunction: #function, inFile: #file)
		}
	}

	public var backgroundColor: JSValue {
		get {
			let pref  = CNPreference.shared.terminalPreference
			let color = pref.backgroundTextColor
			return JSValue(int32: color.escapeCode(), in: mContext)
		}
		set(newval) {
			if newval.isNumber {
				if let col = CNColor.color(withEscapeCode: newval.toInt32()) {
					let pref = CNPreference.shared.terminalPreference
					pref.backgroundTextColor = col
					return
				}
			}
			CNLog(logLevel: .error, message: "Failed to set foregound color", atFunction: #function, inFile: #file)
		}
	}
}

@objc public protocol KLUserPreferenceProtocol: JSExport
{
	var documentDirectory: JSValue { get set }
}

@objc public class KLUserPreference: NSObject, KLUserPreferenceProtocol
{
	private var mContext: KEContext

	public init(context ctxt: KEContext){
		mContext = ctxt
	}

	public var documentDirectory: JSValue {
		get {
			let homeurl = FileManager.default.documentDirectory
			return JSValue(URL: homeurl, in: mContext)
		}
		set(newval) {
			let pref = CNPreference.shared.userPreference
			if let url = newval.toURL() {
				pref.homeDirectory = url
			} else if let str = newval.toString() {
				pref.homeDirectory = URL(fileURLWithPath: str)
			} else {
				CNLog(logLevel: .error, message: "Failed to set Preference.user.homeDirectory", atFunction: #function, inFile: #file)
			}
		}
	}
}

