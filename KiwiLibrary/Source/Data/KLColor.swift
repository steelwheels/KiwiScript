/**
 * @file	KLColor.swift
 * @brief	Define KLColor class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

@objc public protocol KLColorProtocol: JSExport
{
	var red:	JSValue { get }
	var green:	JSValue { get }
	var blue:	JSValue { get }
	var alpha:	JSValue { get }

	func toString() -> JSValue
}

@objc public class KLColor: NSObject, KLColorProtocol {
	private var mColor:	CNColor
	private var mContext:	KEContext

	public var core: CNColor { get { return mColor }}

	public init(color col: CNColor, context ctxt: KEContext) {
		mColor		= col
		mContext	= ctxt
	}

	public var red:    JSValue { get { return anyComponent(component: mColor.redComponent)   }}
	public var green:  JSValue { get { return anyComponent(component: mColor.greenComponent) }}
	public var blue:   JSValue { get { return anyComponent(component: mColor.blueComponent)	 }}
	public var alpha:  JSValue { get { return anyComponent(component: mColor.alphaComponent) }}

	public func toString() -> JSValue {
		let (red, green, blue, alpha) = mColor.toRGBA()
		let str = "Color(red=\(red), green=\(green), blue=\(blue), alpha=\(alpha))"
		return JSValue(object: str, in: mContext)
	}

	private func anyComponent(component comp: CGFloat) -> JSValue {
		return JSValue(double: Double(comp), in: mContext)
	}
}

