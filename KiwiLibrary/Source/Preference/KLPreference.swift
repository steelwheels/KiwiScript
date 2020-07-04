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

open class KLPreferenceTable: CNPreferenceTable
{
	private var mContext:	KEContext
	public var context: KEContext { get { return mContext }}

	public init(sectionName name: String, context ctxt: KEContext) {
		mContext = ctxt
		super.init(sectionName: name)
	}
}

extension CNPreference
{
	public func get<T: KLPreferenceTable>(name nm: String, context ctxt: KEContext, allocator alloc: (_ ctxt: KEContext) -> T) -> T {
		if let anypref = peekTable(name: nm) as? T {
			return anypref
		} else {
			let newpref = alloc(ctxt)
			pokeTable(name: nm, table: newpref)
			return newpref
		}
	}
}

@objc public protocol KLPreferenceProtocol: JSExport
{
	var system: JSValue { get }
}

@objc public protocol KLSystemPreferenceProtocol: JSExport
{
	var version: JSValue { get }
}

@objc public class KLPreference: NSObject, KLPreferenceProtocol
{
	private var mContext: KEContext

	public init(context ctxt: KEContext) {
		mContext = ctxt
	}

	public var system: JSValue { get {
		let pref = KLSystemPreference(context: mContext)
		return JSValue(object: pref, in: mContext)
	}}
}

@objc public class KLSystemPreference: NSObject, KLSystemPreferenceProtocol
{
	private var mContext: KEContext

	public init(context ctxt: KEContext) {
		mContext = ctxt
	}

	public var version: JSValue { get {
		let ver = CNPreference.shared.systemPreference.version
		return JSValue(object: ver, in: mContext)
	}}
}
