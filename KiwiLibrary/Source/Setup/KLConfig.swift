/**
 * @file	KLConfig.swift
 * @brief	Define KLConfig class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiEngine
import Foundation

open class KLConfig: KEConfig
{
	public var doUseGraphicsPrimitive:	Bool

	public override init(kind knd: KEApplicationKind, doStrict strict: Bool, doVerbose verbose: Bool) {
		doUseGraphicsPrimitive = false
		super.init(kind: knd, doStrict: strict, doVerbose: verbose)
	}
}

