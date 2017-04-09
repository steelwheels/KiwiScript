/**
 * @file	KSMath.swift
 * @brief	Define KSMath library class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation
import JavaScriptCore
import Darwin

@objc protocol KSMathOperating : JSExport {
	var PI : Double { get }
	
	func sin(_: JSValue) -> JSValue
	func cos(_: JSValue) -> JSValue
	func tan(_: JSValue) -> JSValue
	func atan(_: JSValue) -> JSValue
}

@objc public class KSMath : NSObject, KSMathOperating
{
	private var mContext : JSContext
	
	public init(context ctxt: JSContext){
		mContext = ctxt
		super.init()
	}
	
	public class func rootObjectName() -> NSString {
		return "Math"
	}
	
	public func registerToContext(context ctxt: JSContext){
		ctxt.setObject(self, forKeyedSubscript: KSMath.rootObjectName())
	}

	var PI : Double {
		get { return Double.pi}
	}
	
	func sin(_ src: JSValue) -> JSValue {
		let val = src.toDouble()
		let result = Darwin.sin(val)
		return JSValue(double: result, in: mContext)
	}
	
	func cos(_ src: JSValue) -> JSValue {
		let val = src.toDouble()
		let result = Darwin.cos(val)
		return JSValue(double: result, in: mContext)
	}
	
	func tan(_ src: JSValue) -> JSValue {
		let val = src.toDouble()
		let result = Darwin.tan(val)
		return JSValue(double: result, in: mContext)
	}
	
	func atan(_ src: JSValue) -> JSValue {
		let val = src.toDouble()
		let result = Darwin.atan(val)
		return JSValue(double: result, in: mContext)
	}
}
