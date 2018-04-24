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

@objc public protocol KLAuthorizeProtocol: JSExport
{
	var Undetermined	: JSValue { get }
	var Denied		: JSValue { get }
	var Authorized		: JSValue { get }
}

@objc public class KLAuthorize: NSObject, KLAuthorizeProtocol
{
	private var mContext: KEContext

	public init(context ctxt: KEContext){
		mContext = ctxt
	}

	public var Undetermined 	: JSValue { get { return accessValue(state: .Undetermined	) }}
	public var Denied		: JSValue { get { return accessValue(state: .Denied		) }}
	public var Authorized		: JSValue { get { return accessValue(state: .Authorized		) }}

	private func accessValue(state s: CNAuthorizeState) -> JSValue {
		return JSValue(int32: Int32(s.rawValue), in: mContext)
	}

}
