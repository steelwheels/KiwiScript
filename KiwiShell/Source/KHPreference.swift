/**
 * @file	KHPreference.swift
 * @brief	Extend KLPreference class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

import CoconutData
import KiwiLibrary
import KiwiEngine
import JavaScriptCore
import Foundation

extension CNPreference
{
	public func shellPreference(context ctxt: KEContext) -> KHShellPreference {
		return get(name: KHShellPreference.preferenceName, context: ctxt, allocator: {
			(_ ctxt: KEContext) -> KHShellPreference in
			return KHShellPreference(context: ctxt)
		})
	}
}

public protocol KHShellPreferenceProtocol: JSExport
{
	var prompt: JSValue { set get }
}

public class KHShellPreference: KLPreferenceTable, KHShellPreferenceProtocol
{
	public static let preferenceName = "shell"

	var mPrompt:	JSValue

	public init(context ctxt: KEContext){
		mPrompt = JSValue(nullIn: ctxt)
		super.init(sectionName: KHShellPreference.preferenceName, context: ctxt)
	}

	public var prompt: JSValue {
		get	 { return mPrompt }
		set(val) { mPrompt = val }
	}
}


