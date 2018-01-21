/**
 * @file	KLRequire.swift
 * @brief	Extend KLRequire function
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiEngine
import JavaScriptCore
import Foundation

public func KLAllocateRequireFunction(context ctxt: KEContext) -> JSValue
{
	let require: @convention(block) (_ value: JSValue) -> JSValue = {
		(_ value: JSValue) -> JSValue in
		if value.isString {
			if let pathstr = value.toString() {
				let manager = KLModuleManager.shared
				if let obj = manager.getModule(moduleName: pathstr) {
					return JSValue(object: obj, in: ctxt)
				}
			}
		}
		return JSValue(nullIn: ctxt)
	}
	return JSValue(object: require, in: ctxt)
}

