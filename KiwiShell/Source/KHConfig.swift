/**
 * @file	KHConfig.swift
 * @brief	Define KHConfig class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import Foundation

open class KHConfig: KEConfig
{
	private var mHasMainFunction:		Bool

	public var hasMainFunction: Bool { get { return mHasMainFunction }}

	public init(applicationType atype: KEApplicationType, hasMainFunction hasmain: Bool, doStrict strict: Bool, logLevel log: CNConfig.LogLevel) {
		mHasMainFunction = hasmain
		super.init(applicationType: atype, doStrict: strict, logLevel: log)
	}
}

