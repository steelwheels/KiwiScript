/**
 * @file	KLCurses.swift
 * @brief	Define KLCurses class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

@objc public protocol KLCursesProtocol: JSExport
{
	var width:  JSValue { get }
	var height: JSValue { get }
}

@objc  public class KLCurses: NSObject, KLCursesProtocol
{
	private var mCurses:	CNCurses
	private var mContext:	KEContext

	public init(curses crs: CNCurses, context ctxt: KEContext) {
		mCurses  = crs
		mContext = ctxt
	}

	public var width: JSValue {
		get { return JSValue(int32: Int32(mCurses.size.width), in: mContext) }
	}

	public var height: JSValue {
		get { return JSValue(int32: Int32(mCurses.size.height), in: mContext) }
	}
}

