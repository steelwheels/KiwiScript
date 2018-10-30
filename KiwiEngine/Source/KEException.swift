/**
 * @file	KEException.swift
 * @brief	Extend KEException class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import JavaScriptCore
import Foundation

public enum KEException {
	case exception(KEContext, JSValue?)	// context, error-object
	case finished(KEContext, JSValue?)	// context, result-value
	case terminated(KEContext)

	public var description: String {
		get {
			var result: String
			switch self {
			case .exception(_, let value):
				let valstr = valueToString(value: value)
				result = "exception(\(valstr))"
			case .finished(_, let value):
				let valstr = valueToString(value: value)
				result = "finished(\(valstr))"
			case .terminated(_):
				result = "terminated()"
			}
			return result
		}
	}

	private func valueToString(value val: JSValue?) -> String {
		let valstr: String
		if let v = val {
			valstr = v.description
		} else {
			valstr = "undefined"
		}
		return valstr
	}
}

