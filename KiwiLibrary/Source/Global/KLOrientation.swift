/**
 * @file	KLOrientation.swift
 * @brief	Define KLOrientation type
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

@objc public protocol KLOrientationProtocol: JSExport
{
	var Horizontal:		JSValue { get }
	var Vertical:		JSValue { get }
}

@objc public class KLOrientation: NSObject, KLOrientationProtocol
{
	private var mContext: KEContext

	public init(context ctxt: KEContext){
		mContext = ctxt
	}

	public var Horizontal 	: JSValue { get { return alignValue(value: CNOrientation.Horizontal.rawValue) }}
	public var Vertical	: JSValue { get { return alignValue(value: CNOrientation.Vertical.rawValue) }}

	private func alignValue(value v: Int32) -> JSValue {
		return JSValue(int32: Int32(v), in: mContext)
	}
}

