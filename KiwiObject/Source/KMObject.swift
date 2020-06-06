/**
 * @file	KMObject.swift
 * @brief	Define KMObject data structure
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

import Foundation

public enum KMValue
{
	case bool(Bool)
	case int(Int)
	case float(Double)
	case string(String)
	case object(String, KMObject)	// class name, object
}

public class KMProperty
{
	public var	name	: String
	public var	value	: KMValue

	public init(name nm: String, value val: KMValue){
		name	= nm
		value	= val
	}
}

public class KMObject
{
	private var mProperties: Array<KMProperty>

	public var properties: Array<KMProperty> { get { return mProperties }}

	public init() {
		mProperties = []
	}

	public init(properties props: Array<KMProperty>){
		mProperties = props
	}
}
