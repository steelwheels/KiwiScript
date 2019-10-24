/**
 * @file	KEConfig.swift
 * @brief	Extend KEConfig class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
import Foundation

public enum KEApplicationKind: Int32 {
	case Terminal
	case Window
	case Operation

	public func description() -> String {
		let result: String
		switch self {
		case .Terminal: 	result = "terminal"
		case .Window:		result = "window"
		case .Operation:	result = "operation"
		}
		return result
	}
}

open class KEConfig: CNConfig
{
	public var	kind:		KEApplicationKind
	public var	doStrict:	Bool

	public init(kind knd: KEApplicationKind, doStrict strict: Bool, logLevel log: CNConfig.LogLevel) {
		kind	  = knd
		doStrict  = strict
		super.init(logLevel: log)
	}
}

