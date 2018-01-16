/**
 * @file	KLColor.swift
 * @brief	Extend KLColor class
 * @par Copyright
 *   Copyright (C) 2017-2018 Steel Wheels Project
 */

import Canary
import KiwiEngine
import JavaScriptCore
import Foundation

@objc public protocol KLColorProtocol: JSExport
{
	var Black	: JSValue { get }
	var Red		: JSValue { get }
	var Green	: JSValue { get }
	var Yellow	: JSValue { get }
	var Blue	: JSValue { get }
	var Magenta	: JSValue { get }
	var Cyan	: JSValue { get }
	var White	: JSValue { get }
}

@objc public class KLColor: NSObject, KLColorProtocol
{
	private var mContext: KEContext

	public init(context ctxt: KEContext){
		mContext = ctxt
	}

	public var Black	: JSValue { get { return colorValue(color: .Black	) }}
	public var Red		: JSValue { get { return colorValue(color: .Red		) }}
	public var Green	: JSValue { get { return colorValue(color: .Green	) }}
	public var Yellow	: JSValue { get { return colorValue(color: .Yellow	) }}
	public var Blue		: JSValue { get { return colorValue(color: .Blue	) }}
	public var Magenta	: JSValue { get { return colorValue(color: .Magenta	) }}
	public var Cyan		: JSValue { get { return colorValue(color: .Cyan	) }}
	public var White	: JSValue { get { return colorValue(color: .White	) }}

	private func colorValue(color col: CNColor) -> JSValue {
		return JSValue(int32: col.rawValue, in: mContext)
	}
}


