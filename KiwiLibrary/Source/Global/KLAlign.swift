/**
 * @file	KLAlign.swift
 * @brief	Define KLAlign type
 * @par Copyright
 *   Copyright (C) 2017-2018 Steel Wheels Project
 */

import KiwiEngine
import JavaScriptCore
import Foundation

public class KLAlign: KEDefaultObject
{
	static public let Left:		Int32		= 0
	static public let Center:	Int32		= 2
	static public let Right:	Int32		= 1

	static public let Top:		Int32		= 0
	static public let Middle:	Int32		= 2
	static public let Bottom:	Int32		= 1

	public override init(instanceName iname: String, context ctxt: KEContext){
		super.init(instanceName: iname, context: ctxt)

		set(name: "left",	int32Value: KLAlign.Left)
		set(name: "center",	int32Value: KLAlign.Center)
		set(name: "right",	int32Value: KLAlign.Right)

		set(name: "top",	int32Value: KLAlign.Top)
		set(name: "middle",	int32Value: KLAlign.Middle)
		set(name: "bottom",	int32Value: KLAlign.Bottom)
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
