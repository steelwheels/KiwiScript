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
	
	func sin(src: JSValue) -> JSValue
	func cos(src: JSValue) -> JSValue
	func tan(src: JSValue) -> JSValue
	func atan(src: JSValue) -> JSValue
}

@objc public class KSMath : NSObject, KSMathOperating
{
	private var mContext : JSContext
	
	public init(context ctxt: JSContext){
		mContext = ctxt
		super.init()
	}
	
	public class func rootObjectName() -> String {
		return "Math"
	}
	
	public func registerToContext(context ctxt: JSContext){
		ctxt.setObject(self, forKeyedSubscript: KSMath.rootObjectName())
	}

	var PI : Double {
		get { return M_PI}
	}
	
	func sin(src: JSValue) -> JSValue {
		let val = src.toDouble()
		let result = Darwin.sin(val)
		return JSValue(double: result, inContext: mContext)
	}
	
	func cos(src: JSValue) -> JSValue {
		let val = src.toDouble()
		let result = Darwin.cos(val)
		return JSValue(double: result, inContext: mContext)
	}
	
	func tan(src: JSValue) -> JSValue {
		let val = src.toDouble()
		let result = Darwin.tan(val)
		return JSValue(double: result, inContext: mContext)
	}
	
	func atan(src: JSValue) -> JSValue {
		let val = src.toDouble()
		let result = Darwin.atan(val)
		return JSValue(double: result, inContext: mContext)
	}
}
