/**
 * @file	KLAlign.swift
 * @brief	Extend KLAlign class
 * @par Copyright
 *   Copyright (C) 2017-2018 Steel Wheels Project
 */

import KiwiEngine
import JavaScriptCore
import Foundation

@objc public protocol KLAlignProtocol: JSExport
{
	var Left	: JSValue { get }
	var Center	: JSValue { get }
	var Right	: JSValue { get }

	var Top		: JSValue { get }
	var Middle	: JSValue { get }
	var Bottom	: JSValue { get }
}

@objc public class KLAlign: NSObject, KLAlignProtocol
{
	private var mContext: KEContext

	public init(context ctxt: KEContext){
		mContext = ctxt
	}

	public var Left 	: JSValue { get { return alignValue(value: 0) }}
	public var Center	: JSValue { get { return alignValue(value: 2) }}
	public var Right	: JSValue { get { return alignValue(value: 1) }}

	public var Top		: JSValue { get { return alignValue(value: 0) }}
	public var Middle	: JSValue { get { return alignValue(value: 2) }}
	public var Bottom	: JSValue { get { return alignValue(value: 1) }}

	private func alignValue(value v: Int) -> JSValue {
		return JSValue(int32: Int32(v), in: mContext)
	}

}

