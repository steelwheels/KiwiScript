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
	private var mTable: 	CNValueTable
	private var mContext:	KEContext

	public init(table tbl: CNValueTable, context ctxt: KEContext){
		mTable		= tbl
		mContext	= ctxt
	}

	public var recordCount: JSValue { get {
		return JSValue(int32: Int32(mTable.recordCount), in: mContext)
	}}

	public func core() -> CNTable {
		return mTable
	}

	public func newRecord() -> JSValue {
		if let rec = mTable.newRecord() as? CNValueRecord {
			let newrec = allocateRecord(record: rec)
			return JSValue(object: newrec, in: mContext)
		} else {
			CNLog(logLevel: .error, message: "Unexpected record type", atFunction: #function, inFile: #file)
			return JSValue(nullIn: mContext)
		}
	}

	public func record(_ row: JSValue) -> JSValue {
		if row.isNumber {
			let ridx = row.toInt32()
			if let rec = mTable.record(at: Int(ridx)) as? CNValueRecord {
				let newrec = allocateRecord(record: rec)
				return JSValue(object: newrec, in: mContext)
			} else {
				CNLog(logLevel: .error, message: "Unexpected record type")
			}
		}
		return JSValue(nullIn: mContext)
	}

	public func append(_ rcd: JSValue) {
		if rcd.isObject {
			if let rec = rcd.toObject() as? KLValueRecord {
				mTable.append(record: rec.core())
			}
		}
	}

	public func forEach(_ callback: JSValue) {
		mTable.forEach(callback: {
			(_ rec: CNRecord) -> Void in
			if let nrec = rec as? CNValueRecord {
				let vrec = allocateRecord(record: nrec)
				if let vobj = JSValue(object: vrec, in: mContext) {
					callback.call(withArguments: [vobj])
				}
			} else {
				CNLog(logLevel: .error, message: "Unexpected record type")
			}
		})
	}

	private func allocateRecord(record rec: CNValueRecord) -> KLValueRecord {
		return KLValueRecord(record: rec, context: mContext)
	}


}

