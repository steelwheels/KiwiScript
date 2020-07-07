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
		set(anyValue: val, forKey: key)
	}

	func scriptValue(forKey key: String) -> JSValue? {
		if let val = anyValue(forKey: key) as? JSValue {
			return val
		} else {
			return nil
		}
	}
}

@objc public protocol KLPreferenceProtocol: JSExport
{
	var system: JSValue { get }
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
}

@objc public protocol KLSystemPreferenceProtocol: JSExport
{
	var version: JSValue { get }
}

@objc public class KLSystemPreference: NSObject, KLSystemPreferenceProtocol
{
	private var mContext: KEContext

	public init(context ctxt: KEContext){
		mContext = ctxt
	}

	public var version: JSValue { get {
		let syspref = CNPreference.shared.systemPreference
		let verstr  = syspref.version
		return JSValue(object: verstr, in: mContext)
	}}
}

