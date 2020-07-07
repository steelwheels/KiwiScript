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
	public var shellPreference: CNShellPreference {
		return get(name: CNShellPreference.PreferenceName, allocator: {
			() -> CNShellPreference in
			return CNShellPreference()
		})
	}
}

public class CNShellPreference: CNPreferenceTable
{
	public static let PreferenceName	= "shell"
	public static let PromptItem		= "prompt"

	public init() {
		super.init(sectionName: "shell")
	}

	public var prompt: JSValue? {
		get {
			if let val = super.scriptValue(forKey: CNShellPreference.PromptItem) {
				return val
			} else {
				return nil
			}
		}
		set(newval) {
			if let val = newval {
				super.set(scriptValue: val, forKey: CNShellPreference.PromptItem)
			}
		}
	}
}

@objc public protocol KHPreferenceProtocol: JSExport
{
	var shell: JSValue { get }
}

@objc public class KHPreference: KLPreference, KHPreferenceProtocol
{
	public var shell: JSValue {
		get {
			let newpref = KHShellPreference(context: super.context)
			return JSValue(object: newpref, in: self.context)
		}
	}
}

@objc public protocol KHShellPreferenceProtocol: JSExport
{
	var prompt: JSValue { set get }
}

@objc public class KHShellPreference: NSObject, KHShellPreferenceProtocol
{
	public static let preferenceName = "shell"

	private var mContext: KEContext

	public init(context ctxt: KEContext) {
		mContext = ctxt
	}

	public var prompt: JSValue {
		set(newval){
			let shellpref = CNPreference.shared.shellPreference
			shellpref.prompt = newval
		}
		get {
			let shellpref = CNPreference.shared.shellPreference
			if let val = shellpref.prompt {
				return val
			} else {
				return JSValue(nullIn: mContext)
			}
		}
	}
}


