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
	private var mTable: 	CNNativeValueTable
	private var mContext:	KEContext

	public init(table tbl: CNNativeValueTable, context ctxt: KEContext){
		mTable		= tbl
		mContext	= ctxt
	}

	public var recordCount: JSValue { get {
		return JSValue(int32: Int32(mTable.recordCount), in: mContext)
	}}

	public func core() -> CNTable {
		return mTable
	}

	public func authorize(_ callback: JSValue) {
		/* Do nothing and return true */
		if let param = JSValue(bool: true, in: mContext) {
			callback.call(withArguments: [param])
		}
	}

	public func load(_ urlp: JSValue) -> JSValue {
		let url: URL?
		if urlp.isURL {
			url = urlp.toURL()
		} else if urlp.isNull {
			url = nil
		} else {
			// Unexpected input URL, return false
			return JSValue(bool: false, in: mContext)
		}
		let result: Bool
		switch mTable.load(URL: url) {
		case .ok:
			result = true
		case .error(let err):
			CNLog(logLevel: .error, message: "Failed to load table value: \(err.toString())")
			result = false
		@unknown default:
			CNLog(logLevel: .error, message: "Unexpected result")
			result = false
		}
		return JSValue(bool: result, in: mContext)
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

	public func save() {
		NSLog("Not supported now")
	}

	private func allocateRecord(record rec: CNValueRecord) -> KLValueRecord {
		return KLValueRecord(record: rec, context: mContext)
	}


}

