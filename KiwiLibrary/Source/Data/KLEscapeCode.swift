/**
 * @file	KLEscapeCode.swift
 * @brief	Define KLEscapeCode class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

@objc public protocol KLEscapeCodeProtocol: JSExport
{
	func color(_ type: JSValue, _ color: JSValue) -> JSValue
}

@objc public class KLEscapeCode: NSObject, KLEscapeCodeProtocol
{
	private var mContext: KEContext

	public enum Target: Int32 {
		case	background = 0
		case	forground  = 1
	}

	public init(context ctxt: KEContext){
		mContext = ctxt
	}

	public func color(_ type: JSValue, _ color: JSValue) -> JSValue {
		var result: String? = nil
		if let targ = Target(rawValue: type.toInt32()), let col = CNColor(rawValue: color.toInt32()) {
			switch targ {
			case .forground:
				result = CNEscapeCode.foregroundColor(col).encode()
			case .background:
				result = CNEscapeCode.backgroundColor(col).encode()
			}
		}
		if let resstr = result {
			return JSValue(object: resstr, in: mContext)
		} else {
			return JSValue(nullIn: mContext)
		}
	}
}

