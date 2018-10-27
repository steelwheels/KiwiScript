/**
 * @file	KLAlign.swift
 * @brief	Define KLAlign type
 * @par Copyright
 *   Copyright (C) 2017-2018 Steel Wheels Project
 */

import KiwiEngine
import KiwiObject
import JavaScriptCore
import Foundation

public class KLAlignment: KMDefaultObject
{
	static public let Left:		Int32		= 0
	static public let Center:	Int32		= 1
	static public let Right:	Int32		= 2

	static public let Top:		Int32		= 3
	static public let Middle:	Int32		= 4
	static public let Bottom:	Int32		= 5

	public override init(instanceName iname: String, context ctxt: KEContext){
		super.init(instanceName: iname, context: ctxt)

		set(name: "left",	int32Value: KLAlignment.Left)
		set(name: "center",	int32Value: KLAlignment.Center)
		set(name: "right",	int32Value: KLAlignment.Right)

		set(name: "top",	int32Value: KLAlignment.Top)
		set(name: "middle",	int32Value: KLAlignment.Middle)
		set(name: "bottom",	int32Value: KLAlignment.Bottom)
	}
}

/* map NSTextAlignment to KLAlign */
public extension NSTextAlignment
{
	public static func valueToAlign(value val: JSValue) -> NSTextAlignment? {
		if val.isNumber {
			let result: NSTextAlignment?
			switch val.toInt32(){
			case KLAlignment.Left:
				result = .left
			case KLAlignment.Right:
				result = .right
			case KLAlignment.Center:
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
			immval = KLAlignment.Left
		case .center:
			immval = KLAlignment.Center
		case .right:
			immval = KLAlignment.Right
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
