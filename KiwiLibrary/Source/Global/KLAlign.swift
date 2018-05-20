/**
 * @file	KLAlign.swift
 * @brief	Define KLAlign type
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
	static public let leftValue:	Int32		= 0
	static public let centerValue:	Int32		= 2
	static public let rightValue:	Int32		= 1

	static public let topValue:	Int32		= 0
	static public let middleValue:	Int32		= 2
	static public let bottomValue:	Int32		= 1

	private var mContext: KEContext

	public init(context ctxt: KEContext){
		mContext = ctxt
	}

	public var Left 	: JSValue { get { return alignValue(value: KLAlign.leftValue) }}
	public var Center	: JSValue { get { return alignValue(value: KLAlign.centerValue) }}
	public var Right	: JSValue { get { return alignValue(value: KLAlign.rightValue) }}

	public var Top		: JSValue { get { return alignValue(value: KLAlign.topValue) }}
	public var Middle	: JSValue { get { return alignValue(value: KLAlign.middleValue) }}
	public var Bottom	: JSValue { get { return alignValue(value: KLAlign.bottomValue) }}

	private func alignValue(value v: Int32) -> JSValue {
		return JSValue(int32: Int32(v), in: mContext)
	}

}

/* map NSTextAlignment to KLAlign */
public extension NSTextAlignment
{
	public static func valueToAlign(value val: JSValue) -> NSTextAlignment? {
		if val.isNumber {
			let result: NSTextAlignment?
			switch val.toInt32(){
			case KLAlign.leftValue:
				result = .left
			case KLAlign.rightValue:
				result = .right
			case KLAlign.centerValue:
				result = .center
			default:
				result = nil
			}
			return result
		}
		return nil
	}

	public static func alignToValue(alignment align: NSTextAlignment, context ctxt: KEContext) -> JSValue? {
		let immval : Int32?
		switch align {
		case .left:
			immval = KLAlign.leftValue
		case .center:
			immval = KLAlign.centerValue
		case .right:
			immval = KLAlign.rightValue
		default:
			immval = nil
		}
		if let iv = immval {
			return JSValue(int32: iv, in: ctxt)
		} else {
			return nil
		}
	}
}
