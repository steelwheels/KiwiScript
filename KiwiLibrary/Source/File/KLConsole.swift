/**
 * @file	KLConsole.swift
 * @brief	Extend KLConsole class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Canary
import KiwiEngine
import JavaScriptCore
import Foundation

@objc public protocol KLConsoleProtocol: JSExport
{
	func log(_ value: JSValue)
	func error(_ value: JSValue)

	var visiblePrompt	: JSValue { get set }
	var doBuffering		: JSValue { get set }
	var doEcho		: JSValue { get set }

	var screenWidth		: JSValue { get }
	var screenHeight	: JSValue { get }
	var cursorX		: JSValue { get }
	var cursorY		: JSValue { get }

	func setColor(_ fcol: JSValue, _ bcol: JSValue)
	func moveTo(_ x: JSValue, _ y:JSValue)

	func setScreenMode(_ mode: JSValue)
	
	func getKey() -> JSValue
}

@objc public class KLConsole: NSObject, KLConsoleProtocol
{
	private var mContext: KEContext
	private var mConsole: CNCursesConsole

	public init(context ctxt: KEContext, console cons: CNCursesConsole){
		mContext = ctxt
		mConsole = cons
	}

	public func log(_ value: JSValue){
		mConsole.print(string: value.toString())
	}

	public func error(_ value: JSValue){
		mConsole.error(string: value.toString())
	}

	public func setScreenMode(_ mode: JSValue){
		if mode.isBoolean {
			let m : CNCursesConsole.ConsoleMode
			if mode.toBool() {
				m = .Screen
			} else {
				m = .Shell
			}
			mConsole.setMode(mode: m)
		}
	}

	public var visiblePrompt: JSValue {
		get {
			let result = mConsole.visiblePrompt
			return JSValue(bool: result, in: mContext)
		}
		set(value){
			if value.isBoolean {
				mConsole.visiblePrompt = value.toBool()
			}
		}
	}

	public var doBuffering: JSValue {
		get {
			let result = mConsole.doBuffering
			return JSValue(bool: result, in: mContext)
		}
		set(value){
			if value.isBoolean {
				mConsole.doBuffering = value.toBool()
			}
		}
	}

	public var doEcho: JSValue {
		get {
			let result = mConsole.doEcho
			return JSValue(bool: result, in: mContext)
		}
		set(value){
			if value.isBoolean {
				mConsole.doEcho = value.toBool()
			}
		}
	}

	public var screenWidth : JSValue {
		get {
			let width = mConsole.screenWidth
			return JSValue(int32: Int32(width), in: mContext)
		}
	}
	public var screenHeight	: JSValue {
		get {
			let height = mConsole.screenHeight
			return JSValue(int32: Int32(height), in: mContext)
		}
	}
	public var cursorX : JSValue {
		get {
			let x = mConsole.cursorX
			return JSValue(int32: Int32(x), in: mContext)
		}
	}
	public var cursorY : JSValue {
		get {
			let y = mConsole.cursorY
			return JSValue(int32: Int32(y), in: mContext)
		}
	}

	public func setColor(_ fval: JSValue, _ bval: JSValue){
		if fval.isNumber && bval.isNumber {
			let fnum = fval.toInt32()
			let bnum = bval.toInt32()
			if let fcol = CNColor(rawValue: fnum), let bcol = CNColor(rawValue: bnum) {
				mConsole.setColor(foregroundColor: fcol, backgroundColor: bcol)
				return
			}
		}
		NSLog("Failed to set color: \(fval.description) \(bval.description)")
	}

	public func moveTo(_ x: JSValue, _ y:JSValue) {
		if x.isNumber && y.isNumber {
			let xval = x.toInt32()
			let yval = y.toInt32()
			mConsole.moveTo(x: Int(xval), y: Int(yval))
		} else {
			NSLog("Invalid parameters")
		}
	}

	public func getKey() -> JSValue {
		if let val = mConsole.getKey() {
			return JSValue(int32: val, in: mContext)
		} else {
			return JSValue(nullIn: mContext)
		}
	}
}


