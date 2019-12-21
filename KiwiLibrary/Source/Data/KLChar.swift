/**
 * @file	KLChar.swift
 * @brief	Define KLChar object
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

@objc public protocol KLCharProtocol: JSExport
{
	var	BS:	JSValue { get }
	var	TAB:	JSValue { get }
	var	LF:	JSValue { get }
	var	VT:	JSValue { get }
	var	CR:	JSValue { get }
	var 	ESC:	JSValue { get }
	var 	DEL:	JSValue { get }
}

@objc public class KLChar: NSObject, KLCharProtocol
{
	private var mContext:	KEContext

	public init(context ctxt: KEContext){
		mContext	= ctxt
	}

	public var BS:  JSValue { get { return charToValue(char: Character.BS ) }}
	public var TAB: JSValue { get { return charToValue(char: Character.TAB) }}
	public var LF:  JSValue { get { return charToValue(char: Character.LF ) }}
	public var VT:  JSValue { get { return charToValue(char: Character.VT ) }}
	public var CR:  JSValue { get { return charToValue(char: Character.CR ) }}
	public var ESC: JSValue { get { return charToValue(char: Character.ESC) }}
	public var DEL: JSValue { get { return charToValue(char: Character.DEL) }}

	private func charToValue(char c: Character) -> JSValue {
		let str = String(c)
		return JSValue(object: str, in: mContext)
	}
}

