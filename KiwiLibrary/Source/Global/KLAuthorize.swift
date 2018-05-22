/**
 * @file	KLAuthorize.swift
 * @brief	Extend KLAuthorize class
 * @par Copyright
 *   Copyright (C) 2017-2018 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

public class KLAuthorize: KEEnumObject
{
	public static let Undetermined	= CNAuthorizeState.Undetermined.rawValue
	public static let Denied	= CNAuthorizeState.Denied.rawValue
	public static let Authorized	= CNAuthorizeState.Authorized.rawValue

	public override init(context ctxt: KEContext) {
		super.init(context: ctxt)

		set(name: "undetermined", 	value: KLAuthorize.Undetermined)
		set(name: "denied",		value: KLAuthorize.Denied)
		set(name: "authorized",		value: KLAuthorize.Authorized)
	}
}


