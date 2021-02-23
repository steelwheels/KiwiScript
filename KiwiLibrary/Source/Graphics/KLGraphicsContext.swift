/**
 * @file	KLGraphicsContext.swift
 * @brief	Define KLGraphicsContext class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation

@objc public protocol KLGraphicsContextProtocol: JSExport
{
	var black:	JSExport { get }
	var red:	JSExport { get }
	var green:	JSExport { get }
	var yellow:	JSExport { get }
	var blue:	JSExport { get }
	var magenta:	JSExport { get }
	var cyan:	JSExport { get }
	var white:	JSExport { get }
	var clear:	JSExport { get }

	var logicalFrame: JSValue { get }

	func setFillColor(_ val: JSValue)
	func setStrokeColor(_ val: JSValue)
	func setPenSize(_ val: JSValue)
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

	public var black: 	JSExport { get { return KLColor(color: CNColor.black,   context: mJContext) }}
	public var red: 	JSExport { get { return KLColor(color: CNColor.red,     context: mJContext) }}
	public var green: 	JSExport { get { return KLColor(color: CNColor.green,   context: mJContext) }}
	public var yellow: 	JSExport { get { return KLColor(color: CNColor.yellow,  context: mJContext) }}
	public var blue: 	JSExport { get { return KLColor(color: CNColor.blue,    context: mJContext) }}
	public var magenta: 	JSExport { get { return KLColor(color: CNColor.magenta, context: mJContext) }}
	public var cyan: 	JSExport { get { return KLColor(color: CNColor.cyan,    context: mJContext) }}
	public var white: 	JSExport { get { return KLColor(color: CNColor.white,   context: mJContext) }}
	public var clear: 	JSExport { get { return KLColor(color: CNColor.clear,   context: mJContext) }}

	public var logicalFrame: JSValue {
		get {
			return JSValue(rect: mGContext.logicalFrame, in: mJContext)
		}
	}

	public func setFillColor(_ val: JSValue) {
		if let col = val.toObject() as? KLColor {
			mGContext.setFillColor(color: col.core)
		} else {
			mConsole.error(string: "Invalid parameter at \(#function)\n")
		}
	}

	public func setStrokeColor(_ val: JSValue) {
		if let col = val.toObject() as? KLColor {
			mGContext.setStrokeColor(color: col.core)
		} else {
			mConsole.error(string: "Invalid parameter at \(#function)\n")
		}
	}

	public func setPenSize(_ val: JSValue) {
		if val.isNumber {
			let width = val.toDouble()
			mGContext.setPenSize(width: CGFloat(width))
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

