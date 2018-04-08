/**
 * @file	KLGlobalManager.swift
 * @brief	Define KLGlobalManager class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiEngine
import JavaScriptCore
import Foundation

public class KLGlobalManager
{
	public static var shared: KLGlobalManager = KLGlobalManager()

	private var mContext:	KEContext?

	private init(){
		mContext = nil
	}

	public func setup(context ctxt: KEContext){
		mContext = ctxt
	}

	private func addObject(name nm: String, object obj: Any){
		if let context = mContext {
			if let val = JSValue(object: obj, in: context){
				context.set(name: nm, value: val)
			}
		}
		NSLog("Failed to allocate object for \(nm)")
	}

	public func setTypeCheckFunctions(){
		/* isUndefined */
		let isUndefinedFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			let result: Bool = value.isUndefined
			return JSValue(bool: result, in: self.mContext)
		}
		addObject(name: "isUndefined", object: isUndefinedFunc)

		/* isNull */
		let isNullFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			let result: Bool = value.isNull
			return JSValue(bool: result, in: self.mContext)
		}
		addObject(name: "isNull", object: isNullFunc)

		/* isBoolean */
		let isBooleanFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			let result: Bool = value.isBoolean
			return JSValue(bool: result, in: self.mContext)
		}
		addObject(name: "isBoolean", object: isBooleanFunc)

		/* isNumber */
		let isNumberFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			let result: Bool = value.isNumber
			return JSValue(bool: result, in: self.mContext)
		}
		addObject(name: "isNumber", object: isNumberFunc)

		/* isString */
		let isStringFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			let result: Bool = value.isString
			return JSValue(bool: result, in: self.mContext)
		}
		addObject(name: "isString", object: isStringFunc)

		/* isObject */
		let isObjectFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			let result: Bool = value.isObject
			return JSValue(bool: result, in: self.mContext)
		}
		addObject(name: "isObject", object: isObjectFunc)

		/* isArray */
		let isArrayFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			let result: Bool = value.isArray
			return JSValue(bool: result, in: self.mContext)
		}
		addObject(name: "isArray", object: isArrayFunc)

		/* isDate */
		let isDateFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			let result: Bool = value.isArray
			return JSValue(bool: result, in: self.mContext)
		}
		addObject(name: "isDate", object: isDateFunc)
	}
}

