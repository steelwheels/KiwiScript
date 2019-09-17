/**
 * @file	KHConfig.swift
 * @brief	Define KHConfig class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiEngine
import Foundation

open class KHConfig: KEConfig
{
	public var hasMainFunction:		Bool

	public init(kind knd: KEApplicationKind, hasMainFunction hasmain: Bool, doStrict strict: Bool, doVerbose verbose: Bool) {
		hasMainFunction 	= hasmain
		super.init(kind: knd, doStrict: strict, doVerbose: verbose)
	}
}
