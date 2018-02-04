/**
 * @file	KLAuthorize.swift
 * @brief	Extend KLAuthorize class
 * @par Copyright
 *   Copyright (C) 2017-2018 Steel Wheels Project
 */

import KiwiEngine
import Canary
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

	public var Undetermined 	: JSValue { get { return accessValue(type: .Undetermined	) }}
	public var Denied		: JSValue { get { return accessValue(type: .Denied		) }}
	public var Authorized		: JSValue { get { return accessValue(type: .Authorized		) }}

	private func accessValue(type t: CNAuthorizeType) -> JSValue {
		return JSValue(int32: Int32(t.rawValue), in: mContext)
	}

}
