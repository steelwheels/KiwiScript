/**
 * @file	KLColorManager.swift
 * @brief	Define KLColorManager class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

@objc public protocol KLColorManagerProtocol: JSExport
{
	var black:	JSValue { get }
	var red:	JSValue { get }
	var green:	JSValue { get }
	var yellow:	JSValue { get }
	var blue:	JSValue { get }
	var magenta:	JSValue { get }
	var cyan:	JSValue { get }
	var white:	JSValue { get }
	var clear:	JSValue { get }
}

@objc public class KLColorManager: NSObject, KLColorManagerProtocol
{
	private var mContext: KEContext

	public init(context ctxt: KEContext) {
		mContext = ctxt
	}

	public var black: 	JSValue { get { return allocate(color: CNColor.black	) }}
	public var red:   	JSValue { get { return allocate(color: CNColor.red	) }}
	public var green:	JSValue { get { return allocate(color: CNColor.green	) }}
	public var yellow:	JSValue { get { return allocate(color: CNColor.yellow	) }}
	public var blue:	JSValue { get { return allocate(color: CNColor.blue	) }}
	public var magenta:	JSValue { get { return allocate(color: CNColor.magenta	) }}
	public var cyan:	JSValue { get { return allocate(color: CNColor.cyan	) }}
	public var white:	JSValue { get { return allocate(color: CNColor.white	) }}
	public var clear:	JSValue { get { return allocate(color: CNColor.clear	) }}

	private func allocate(color col: CNColor) -> JSValue {
		let obj = KLColor(color: col, context: mContext)
		return JSValue(object: obj, in: mContext)
	}
}

