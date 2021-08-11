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
	func input()	-> JSValue
	func history()	-> JSValue
}

@objc public class KLReadline: NSObject, KLReadlineProtocol
{
	private var mReadline:		CNReadline
	private var mConsole:		CNFileConsole
	private var mContext:		KEContext
	private var mNullValue:		JSValue

	public init(readline rline: CNReadline, console cons: CNFileConsole, context ctxt: KEContext) {
		mReadline	= rline
		mConsole	= cons
		mContext	= ctxt
		mNullValue 	= JSValue(nullIn: ctxt)
	}

	public func input() -> JSValue {
		let result:String?
		switch mReadline.readLine(console: mConsole) {
		case .string(let str, _):
			result = str
		case .error(let err):
			mConsole.error(string: err.toString())
			result = nil
		case .none:
			result = nil
		@unknown default:
			mConsole.error(string: "Can not happen")
			result = nil
		}
		if let str = result {
			return JSValue(object: str, in: mContext)
		} else {
			return mNullValue
		}
	}

	public func history() -> JSValue {
		return JSValue(object: mReadline.history, in: mContext)
	}
}

