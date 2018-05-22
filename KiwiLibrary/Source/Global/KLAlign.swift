/**
 * @file	KLAlign.swift
 * @brief	Define KLAlign type
 * @par Copyright
 *   Copyright (C) 2017-2018 Steel Wheels Project
 */

import KiwiEngine
import JavaScriptCore
import Foundation

public class KLAlign: KEEnumObject
{
	static public let Left:		Int32		= 0
	static public let Center:	Int32		= 2
	static public let Right:	Int32		= 1

	static public let Top:		Int32		= 0
	static public let Middle:	Int32		= 2
	static public let Bottom:	Int32		= 1

	public override init(context ctxt: KEContext) {
		super.init(context: ctxt)
		set(name: "left", 	value: KLAlign.Left)
		set(name: "center", 	value: KLAlign.Center)
		set(name: "right",	value: KLAlign.Right)

		set(name: "top", 	value: KLAlign.Top)
		set(name: "middle", 	value: KLAlign.Middle)
		set(name: "bottom",	value: KLAlign.Bottom)
	}
}

/* map NSTextAlignment to KLAlign */
public extension NSTextAlignment
{
	public static func valueToAlign(value val: JSValue) -> NSTextAlignment? {
		if val.isNumber {
			let result: NSTextAlignment?
			switch val.toInt32(){
			case KLAlign.Left:
				result = .left
			case KLAlign.Right:
				result = .right
			case KLAlign.Center:
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
			immval = KLAlign.Left
		case .center:
			immval = KLAlign.Center
		case .right:
			immval = KLAlign.Right
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
