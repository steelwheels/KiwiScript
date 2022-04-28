/**
 * @file	KLValueTable.swift
 * @brief	Define KLValueTable class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

@objc public class KLValueTable: NSObject, KLTable, KLTableCore
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

	public func core() -> CNTable {
		return mTable
	}

	public var allFieldNames: JSValue { get {
		return JSValue(object: mTable.allFieldNames, in: mContext)
	}}

	public func record(_ row: JSValue) -> JSValue {
		if row.isNumber {
			let ridx = row.toInt32()
			if let rec = mTable.record(at: Int(ridx)) {
				let newrec = allocateRecord(record: rec)
				return JSValue(object: newrec, in: mContext)
			} else {
				CNLog(logLevel: .error, message: "Unexpected record type")
			}
		}
		return JSValue(nullIn: mContext)
	}

	public func pointer(_ val: JSValue, _ field: JSValue) -> JSValue {
		if field.isString {
			if let fldstr  = field.toString() {
				let propval = val.toNativeValue()
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
				let nval  = val.toNativeValue()
				let recs  = mTable.search(value: nval, forField: fname)
				var result: Array<KLRecord> = []
				for rec in recs {
					result.append(allocateRecord(record: rec))
				}
				return JSValue(object: result, in: mContext)
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
		let val = ptr.toNativeValue()
		switch val {
		case .pointerValue(let ptval):
			mTable.append(pointer: ptval)
		default:
			let txt = ptr.toText().toStrings().joined(separator: "\n")
			CNLog(logLevel: .error, message: "Invalid parameter type: \(txt)", atFunction: #function, inFile: #file)
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
			let vrec = allocateRecord(record: rec)
			if let vobj = JSValue(object: vrec, in: mContext) {
				callback.call(withArguments: [vobj])
			}
		})
	}

	private func allocateRecord(record rec: CNRecord) -> KLRecord {
		return KLRecord(record: rec, context: mContext)
	}

	public func toString() -> JSValue {
		let str = mTable.toValue().toText().toStrings().joined(separator: "\n")
		return JSValue(object: str, in: mContext)
	}
}

