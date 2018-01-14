/**
 * @file	KLConfig.swift
 * @brief	Extend KLConfig class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation

public class KLConfig
{
	public var hasFileLib:		Bool
	public var hasCursesLib:	Bool
	public var hasJSONLib:		Bool

	public init(){
		hasFileLib	= false
		hasCursesLib	= false
		hasJSONLib	= false
	}
}

