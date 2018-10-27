/**
 * @file	KLAuthorize.swift
 * @brief	Extend KLAuthorize class
 * @par Copyright
 *   Copyright (C) 2017-2018 Steel Wheels Project
 */

import KiwiEngine
import KiwiObject
import CoconutData
import JavaScriptCore
import Foundation

public class KLAuthorize: KMDefaultObject
{
	public static let Undetermined	= CNAuthorizeState.Undetermined.rawValue
	public static let Denied	= CNAuthorizeState.Denied.rawValue
	public static let Authorized	= CNAuthorizeState.Authorized.rawValue

	public override init(instanceName iname: String, context ctxt: KEContext){
		super.init(instanceName: iname, context: ctxt)

		set(name: "undetermined",	int32Value: KLAuthorize.Undetermined)
		set(name: "denied",		int32Value: KLAuthorize.Denied)
		set(name: "authorized",		int32Value: KLAuthorize.Authorized)
	}
}


