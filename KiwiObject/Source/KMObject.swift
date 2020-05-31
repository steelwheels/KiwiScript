/**
 * @file	KMObject.swift
 * @brief	Define KMObject data structure
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

import Foundation

public enum KMType {
	case bool
	case int
	case float
	case string
	case text
	case any(String)	// type name
}

public enum KMObject {
	case bool(Bool)
	case int(Int)
	case float(Float)
	case string(String)
	case text(String)
	case properties(Array<KMProperty>)
}

public struct KMProperty {
	var	name:	String
	var	type:	KMType
	var	value:	KMObject

	public init(name nm: String, type tp: KMType, value val: KMObject){
		name  = nm
		type  = tp
		value = val
	}
}
