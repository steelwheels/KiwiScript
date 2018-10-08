/**
 * @file	KEException.swift
 * @brief	Extend KEException class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import JavaScriptCore
import Foundation

public enum KEException {
	case CompileError(String)
	case Evaluated(JSContext, JSValue?)
	case Runtime(String)			// String: message
	case Exit(Int32)
	case Terminated(JSContext, String)

	public var description: String {
		get {
			let result: String
			switch self {
			case .CompileError(let message):
				result = "\(message)"
			case .Evaluated(_, let value):
				if let v = value {
					result = "Evaluated: \(v.description)"
				} else {
					result = "Evaluated: nil"
				}
			case .Runtime(let msg):
				result = "Error: \(msg)"
			case .Exit(let code):
				result = "Exit: \(code)"
			case .Terminated(_, let message):
				result = "Terminated: \(message)"
			}
			return result
		}
	}
}

