/**
 * @file	KLError.swift
 * @brief	Define KLError
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation

public enum KLException {
	case Exit(Int32)		// with Exit code
	case CompileError(String)	// with message

	public var description: String {
		get {
			var result: String
			switch self {
			case .Exit(let code):
				result = "exit with code \(code)"
			case .CompileError(let message):
				result = message
			}
			return result
		}
	}
}


