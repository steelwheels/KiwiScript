/**
 * @file	KLConfig.swift
 * @brief	Define KLConfig class
 * @par Copyright
 *   Copyright (C) 2017-2018 Steel Wheels Project
 */

import KiwiEngine
import Foundation

open class KLConfig: KEConfig
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

	public var	kind		: ApplicationKind

	public init(kind appkind: ApplicationKind){
		#if os(OSX)
			kind 	= .Terminal
		#else
			kind	= .Window
		#endif
		super.init()
	}
}

