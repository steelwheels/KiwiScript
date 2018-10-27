/**
 * @file	KMConfig.swift
 * @brief	Define KMConfig class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiEngine
import JavaScriptCore
import Foundation

public class KMConfig: KMDefaultObject
{
	public enum ApplicationKind: Int32 {
		case Terminal
		case Window

		public func description() -> String {
			let result: String
			switch self {
			case .Terminal: result = "terminal"
			case .Window:	result = "window"
			}
			return result
		}
	}

	static let ApplicationKindProperty	= "applicationKind"
	static let DoVerboseProperty		= "doVerbose"
	static let UseStrictMode		= "useStrictMode"
	static let ScriptFilesProperty		= "scriptFiles"

	public init(kind knd: ApplicationKind, instanceName iname: String, context ctxt: KEContext) {
		super.init(instanceName: iname, context: ctxt)
		self.kind 	   = knd
		self.doVerbose     = false
		self.useStrictMode = true
		self.scriptFiles   = []
	}

	public var kind: ApplicationKind {
		get {
			if let val = self.getInt32(name: KMConfig.ApplicationKindProperty) {
				if let kind = ApplicationKind(rawValue: val) {
					return kind
				}
			}
			let except = KEException.Runtime("No application kind")
			context.exceptionCallback(except)
			return .Terminal
		}
		set(kind) {
			let val = kind.rawValue
			self.set(name: KMConfig.ApplicationKindProperty, int32Value: val)
		}
	}

	public var doVerbose: Bool {
		get {
			if let val = self.getBool(name: KMConfig.DoVerboseProperty) {
				return val
			} else {
				return true
			}
		}
		set(newval){
			self.set(name: KMConfig.DoVerboseProperty, boolValue: newval)
		}
	}

	public var useStrictMode: Bool {
		get {
			if let val = self.getBool(name: KMConfig.UseStrictMode) {
				return val
			} else {
				return true
			}
		}
		set(newval){
			self.set(name: KMConfig.UseStrictMode, boolValue: newval)
		}
	}

	public var scriptFiles: Array<String> {
		get {
			if let val = self.getArray(name: KMConfig.ScriptFilesProperty){
				if let arr = val as? Array<String> {
					return arr
				} else {
					let except = KEException.Runtime("Array does not contain string")
					context.exceptionCallback(except)
					return []
				}
			} else {
				let except = KEException.Runtime("No scriptFiles property")
				context.exceptionCallback(except)
				return []
			}
		}
		set(files) {
			self.set(name: KMConfig.ScriptFilesProperty, arrayValue: files)
		}
	}
}
