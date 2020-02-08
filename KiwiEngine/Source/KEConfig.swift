/**
 * @file	KEConfig.swift
 * @brief	Extend KEConfig class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
import Foundation

public enum KEApplicationType: Int32 {
	case terminal
	case window

	public func description() -> String {
		let result: String
		switch self {
		case .terminal: 	result = "terminal"
		case .window:		result = "window"
		}
		return result
	}
}

open class KEConfig: CNConfig
{
	private var	mApplicationType:	KEApplicationType
	public var	mDoStrict:		Bool

	public var applicationType: 	KEApplicationType	{ get { return mApplicationType }}
	public var doStrict:		Bool			{ get { return mDoStrict	}}

	public init(applicationType atype: KEApplicationType, doStrict strict: Bool, logLevel log: CNConfig.LogLevel) {
		mApplicationType	= atype
		mDoStrict  		= strict
		super.init(logLevel: log)
	}
}

