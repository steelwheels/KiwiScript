/**
 * @file	KHExternalCompiler.swift
 * @brief	Define KHExternalCompiler class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import Foundation

public protocol KHExternalCompiler
{
	func compile(context ctxt: KEContext, config conf: KEConfig) -> Bool
}
