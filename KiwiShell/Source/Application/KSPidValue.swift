/**
 * @file	KSPidValue.swift
 * @brief	Define KSPidValue class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import KiwiEngine
import JavaScriptCore
import Foundation

public class KSPidValue
{
	private var mPid:	Int32

	public init(pid val: Int32){
		mPid = val
	}

	public var processIdentifier: Int32 {
		return mPid
	}

	public class func encode(source src: KSPidValue, context ctxt: KEContext) -> JSValue {
		return JSValue(int32: src.processIdentifier, in: ctxt)
	}

	public class func decode(value val: JSValue) -> KSPidValue? {
		if val.isNumber {
			if let num = val.toNumber() {
				let pid = num.int32Value
				return KSPidValue(pid: pid)
			}
		}
		return nil
	}
}
