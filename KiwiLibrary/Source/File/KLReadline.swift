/**
 * @file	KLReadline.swift
 * @brief	Define KLReadline class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation

@objc public protocol KLReadlineProtocol: JSExport {
	//func input()	-> JSValue
	func history()	-> JSValue
}

@objc public class KLReadline: NSObject, KLReadlineProtocol
{
	private var mReadline:		CNReadline
	private var mContext:		KEContext

	public init(readline rline: CNReadline, context ctxt: KEContext) {
		mReadline	= rline
		mContext	= ctxt
	}

	public func history() -> JSValue {
		return JSValue(object: mReadline.history, in: mContext)
	}
}

