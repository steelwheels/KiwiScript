/**
 * @file	KLGraphicsContext.swift
 * @brief	Extend KLGraphicsContext class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation

@objc public protocol KLGraphicsContextProtocol: JSExport
{
	var black:	JSValue { get }
	var red:	JSValue { get }
	var green:	JSValue { get }
	var yellow:	JSValue { get }
	var blue:	JSValue { get }
	var magenta:	JSValue { get }
	var cyan:	JSValue { get }
	var white:	JSValue { get }

	var logicalFrame: JSValue { get }

	func setFillColor(_ val: JSValue)
	func setStrokeColor(_ val: JSValue)
	func setLineWidth(_ val: JSValue)
	func moveTo(_ xval: JSValue, _ yval: JSValue)
	func lineTo(_ xval: JSValue, _ yval: JSValue)
	func circle(_ xval: JSValue, _ yval: JSValue, _ radval: JSValue)
}

@objc public class KLGraphicsContext: NSObject, KLGraphicsContextProtocol
{
	private var mGContext:	CNGraphicsContext
	private var mJContext:	KEContext
	private var mConsole:	CNConsole

	public init(graphicsContext gctxt: CNGraphicsContext, scriptContext sctxt: KEContext, console cons: CNConsole) {
		mGContext	= gctxt
		mJContext	= sctxt
		mConsole 	= cons
		super.init()
	}

	public var black: 	JSValue { get { return JSValue(object: CNColor.black,	in: mJContext) }}
	public var red:		JSValue { get { return JSValue(object: CNColor.red,	in: mJContext) }}
	public var green:	JSValue { get { return JSValue(object: CNColor.green,	in: mJContext) }}
	public var yellow:	JSValue { get { return JSValue(object: CNColor.yellow,	in: mJContext) }}
	public var blue:	JSValue { get { return JSValue(object: CNColor.blue,	in: mJContext) }}
	public var magenta:	JSValue { get { return JSValue(object: CNColor.magenta,	in: mJContext) }}
	public var cyan:	JSValue { get { return JSValue(object: CNColor.cyan,	in: mJContext) }}
	public var white: 	JSValue { get { return JSValue(object: CNColor.white,	in: mJContext) }}

	public var logicalFrame: JSValue {
		get {
			return JSValue(rect: mGContext.logicalFrame, in: mJContext)
		}
	}

	public func setFillColor(_ val: JSValue) {
		if let col = val.toObject() as? CNColor {
			mGContext.setFillColor(color: col.cgColor)
		} else {
			mConsole.error(string: "Invalid parameter at \(#function)\n")
		}
	}

	public func setStrokeColor(_ val: JSValue) {
		if let col = val.toObject() as? CNColor {
			mGContext.setStrokeColor(color: col.cgColor)
		} else {
			mConsole.error(string: "Invalid parameter at \(#function)\n")
		}
	}

	public func setLineWidth(_ val: JSValue) {
		if val.isNumber {
			let width = val.toDouble()
			mGContext.setLineWidth(width: CGFloat(width))
		} else {
			mConsole.error(string: "Invalid parameter at \(#function)\n")
		}
	}

	public func moveTo(_ xval: JSValue, _ yval: JSValue) {
		if xval.isNumber && yval.isNumber {
			let x = xval.toDouble()
			let y = yval.toDouble()
			mGContext.move(to: CGPoint(x: x, y: y))
		} else {
			mConsole.error(string: "Invalid parameter at \(#function)\n")
		}
	}

	public func lineTo(_ xval: JSValue, _ yval: JSValue) {
		if xval.isNumber && yval.isNumber {
			let x = xval.toDouble()
			let y = yval.toDouble()
			mGContext.line(to: CGPoint(x: x, y: y))
		} else {
			mConsole.error(string: "Invalid parameter at \(#function)\n")
		}
	}

	public func circle(_ xval: JSValue, _ yval: JSValue, _ radval: JSValue) {
		if xval.isNumber && yval.isNumber && radval.isNumber {
			let x   = xval.toDouble()
			let y   = yval.toDouble()
			let rad = radval.toDouble()
			mGContext.circle(center: CGPoint(x: x, y: y), radius: CGFloat(rad))
		} else {
			mConsole.error(string: "Invalid parameter at \(#function)\n")
		}
	}
}
