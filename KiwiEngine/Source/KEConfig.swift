/**
 * @file	KEConfig.swift
 * @brief	Extend KEConfig class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import Foundation

open class KEConfig
{
	public var	doStrict:	Bool
	public var 	doVerbose:	Bool

	public init(doStrict strict: Bool, doVerbose verbose: Bool) {
		doStrict  = strict
		doVerbose = verbose
	}
}

