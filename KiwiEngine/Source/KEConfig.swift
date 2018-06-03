/**
 * @file	KEConfig.swift
 * @brief	Define KEConfig class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import JavaScriptCore
import Foundation

public class KEConfig: KEDefaultObject
{
	static let DoVerboseProperty	= "doVerbose"
	static let UseStrictMode	= "useStrictMode"

	public override init(instanceName iname: String, context ctxt: KEContext) {
		super.init(instanceName: iname, context: ctxt)
		self.doVerbose     = false
		self.useStrictMode = true
	}

	public var doVerbose: Bool {
		get {
			if let val = self.getBool(name: KEConfig.DoVerboseProperty) {
				return val
			} else {
				return true
			}
		}
		set(newval){
			self.set(name: KEConfig.DoVerboseProperty, boolValue: newval)
		}
	}

	public var useStrictMode: Bool {
		get {
			if let val = self.getBool(name: KEConfig.UseStrictMode) {
				return val
			} else {
				return true
			}
		}
		set(newval){
			self.set(name: KEConfig.UseStrictMode, boolValue: newval)
		}
	}
}

