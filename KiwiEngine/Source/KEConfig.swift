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
	public enum ApplicationKind: Int32 {
		case Terminal
		case Window
	}

	static let ApplicationKindProperty	= "applicationKind"
	static let DoVerboseProperty		= "doVerbose"
	static let UseStrictMode		= "useStrictMode"

	public init(kind knd: ApplicationKind, instanceName iname: String, context ctxt: KEContext) {
		super.init(instanceName: iname, context: ctxt)
		self.kind 	   = knd
		self.doVerbose     = false
		self.useStrictMode = true
	}

	public var kind: ApplicationKind {
		get {
			if let val = self.getInt32(name: KEConfig.ApplicationKindProperty) {
				if let kind = ApplicationKind(rawValue: val) {
					return kind
				}
			}
			NSLog("No application kind")
			return .Terminal
		}
		set(kind) {
			let val = kind.rawValue
			self.set(name: KEConfig.ApplicationKindProperty, int32Value: val)
		}
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

