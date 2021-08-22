/**
 * @file	KLValueRecord.swift
 * @brief	Define KLValueRecord class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

@objc public class KLValueRecord: NSObject, KLRecord, KLRecordCore
{
	private var mRecord:	CNNativeValueRecord
	private var mContext:	KEContext

	public init(record rcd: CNNativeValueRecord, context ctxt: KEContext){
		mRecord		= rcd
		mContext	= ctxt
		super.init()
	}

	public func core() -> CNRecord {
		return mRecord
	}

	public var fieldCount: JSValue { get {
		return JSValue(int32: Int32(mRecord.fieldCount), in: mContext)
	}}

	public var fieldNames: JSValue { get {
		return JSValue(object: mRecord.fieldNames, in: mContext)
	}}

	public func value(_ name: JSValue) -> JSValue {
		if name.isString {
			if let nstr = name.toString() {
				if let val = mRecord.value(ofField: nstr) {
					return val.toJSValue(context: mContext)
				}
			}
		}
		return JSValue(nullIn: mContext)
	}

	public func setValue(_ val: JSValue, _ name: JSValue) -> JSValue {
		var result = false
		if name.isString {
			if let nstr = name.toString() {
				result = mRecord.setValue(value: val.toNativeValue(), forField: nstr)
			}
		}
		return JSValue(bool: result, in: mContext)
	}

	public func save() {
		NSLog("Not supported yet")
	}
}

