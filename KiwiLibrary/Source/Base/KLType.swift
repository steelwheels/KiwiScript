/**
 * @file	KLType.swift
 * @brief	General type definitions
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiEngine
import Foundation

public protocol KLEmbeddedObject {
	func copy(context ctxt: KEContext) -> KLEmbeddedObject
}

