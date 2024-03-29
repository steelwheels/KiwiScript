/**
 * @file	KLTable.swift
 * @brief	Define KLTable class
 * @par Copyright
 *   Copyright (C) 2021-2022 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

@objc public protocol KLTableProtocol: JSExport
{
	var recordCount: JSValue { get }
	var defaultFields: JSValue { get }

	func newRecord() -> JSValue
	func record(_ row: JSValue) -> JSValue
	func pointer(_ val: JSValue, _ field: JSValue) -> JSValue

	func search(_ val: JSValue, _ field: JSValue) -> JSValue
	func append(_ rcd: JSValue)
	func appendPointer(_ ptr: JSValue)
	func remove(_ rcd: JSValue) -> JSValue
	func save() -> JSValue

	func forEach(_ callback: JSValue)
}

public protocol KLTableCoreProtocol
{
	func core() -> CNTable
}

@objc open class KLTable: NSObject, KLTableProtocol, KLTableCoreProtocol
{
	private var mTable: 	CNTable
	private var mContext:	KEContext

	public init(table tbl: CNTable, context ctxt: KEContext){
		mTable		= tbl
		mContext	= ctxt
	}

	public var recordCount: JSValue { get {
		return JSValue(int32: Int32(mTable.recordCount), in: mContext)
	}}

	public var context: KEContext { get {
		return mContext
	}}

	public func core() -> CNTable {
		return mTable
	}

	public var defaultFields: JSValue { get {
		var result: Dictionary<String, AnyObject> = [:]
		let conv = CNValueToAnyObject()
		for (key, val) in mTable.defaultFields {
			result[key] = conv.convert(value: val)
		}
		return JSValue(object: result, in: mContext)
	}}

	public func newRecord() -> JSValue {
		let recobj = mTable.newRecord()
		if let val = allocateRecord(record: recobj) {
			return val
		} else {
			CNLog(logLevel: .error, message: "Failed to allocate", atFunction: #function, inFile: #file)
			return JSValue(nullIn: mContext)
		}
	}

	public func record(_ row: JSValue) -> JSValue {
		if row.isNumber {
			let ridx = row.toInt32()
			if let rec = mTable.record(at: Int(ridx)) {
				if let val = allocateRecord(record: rec) {
					return val
				} else {
					CNLog(logLevel: .error, message: "Failed to allocate", atFunction: #function, inFile: #file)
				}
			} else {
				CNLog(logLevel: .error, message: "Unexpected record type", atFunction: #function, inFile: #file)
			}
		}
		return JSValue(nullIn: mContext)
	}

	public func pointer(_ val: JSValue, _ field: JSValue) -> JSValue {
		if field.isString {
			if let fldstr  = field.toString() {
				let conv    = KLScriptValueToNativeValue()
				let propval = conv.convert(scriptValue: val)
				if let ptr = mTable.pointer(value: propval, forField:fldstr) {
					return ptr.toJSValue(context: mContext)
				}
			}
		}
		return JSValue(nullIn: mContext)
	}

	public func search(_ val: JSValue, _ field: JSValue) -> JSValue {
		if field.isString {
			if let fname = field.toString() {
				let conv  = KLScriptValueToNativeValue()
				let nval  = conv.convert(scriptValue: val)
				let recs  = mTable.search(value: nval, forField: fname)
				if recs.count > 0 {
					let objs  = recs.map({ (_ rec: CNRecord) -> KLRecord in
						return KLRecord(record: rec, context: mContext)
					})
					if let res = KLRecord.allocate(records: objs, context: mContext) {
						return res
					} else {
						CNLog(logLevel: .error, message: "Failed to allocate", atFunction: #function, inFile: #file)
					}
				}
			}
		}
		return JSValue(nullIn: mContext)
	}

	public func append(_ rcd: JSValue) {
		if rcd.isObject {
			if let rec = rcd.toObject() as? KLRecord {
				mTable.append(record: rec.core())
			}
		}
	}

	public func appendPointer(_ ptr: JSValue) {
		let conv = KLScriptValueToNativeValue()
		let val  = conv.convert(scriptValue: ptr)
		switch val {
		case .dictionaryValue(let dict):
			if let ptr = CNPointerValue.fromValue(value: dict) {
				mTable.append(pointer: ptr)
			} else {
				CNLog(logLevel: .error, message: "Invalid parameter type: \(ptr.description)", atFunction: #function, inFile: #file)
			}
		default:
			CNLog(logLevel: .error, message: "Invalid parameter type: \(ptr.description)", atFunction: #function, inFile: #file)
		}
	}

	public func remove(_ idxval: JSValue) -> JSValue {
		var result = false
		if idxval.isNumber {
			if let idxnum = idxval.toNumber() {
				let idx = idxnum.intValue
				result = mTable.remove(at: idx)
			}
		}
		return JSValue(bool: result, in: mContext)
	}

	public func save() -> JSValue {
		return JSValue(bool: mTable.save(), in: mContext)
	}

	public func forEach(_ callback: JSValue) {
		mTable.forEach(callback: {
			(_ rec: CNRecord) -> Void in
			if let vobj = allocateRecord(record: rec) {
				callback.call(withArguments: [vobj])
			} else {
				CNLog(logLevel: .error, message: "Failed to allocate", atFunction: #function, inFile: #file)
			}
		})
	}

	private func allocateRecord(record rec: CNRecord) -> JSValue? {
		let rec = KLRecord(record: rec, context: mContext)
		if let val = KLRecord.allocate(record: rec) {
			return val
		} else {
			return nil
		}
	}
}

