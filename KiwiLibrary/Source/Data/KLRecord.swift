/**
 * @file	KLRecord.swift
 * @brief	Define KLRecord class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

@objc public protocol KLRecordIF: JSExport
{
	var fieldCount:		JSValue { get }
	var fieldNames:		JSValue { get }

	func value(_ name: JSValue) -> JSValue
	func setValue(_ val: JSValue, _ name: JSValue) -> JSValue

	func toString() -> JSValue
}

public protocol KLRecordCore
{
	func core() -> CNRecord
}

@objc public class KLRecord: NSObject, KLRecordIF, KLRecordCore
{
	private var mRecord:	CNRecord
	private var mContext:	KEContext

	public init(record rcd: CNRecord, context ctxt: KEContext){
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

	public func toString() -> JSValue {
		let val: CNValue = .dictionaryValue(mRecord.toValue())
		return JSValue(object: val.toText().toStrings().joined(separator: "\n"), in: mContext)
	}
}

