/**
 * @file	KLContactDatabase.swift
 * @brief	Define KLContactDatabase class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import CoconutDatabase
import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation

@objc public protocol KLContactTable: JSExport
{
	func authorize(_ callback: JSValue)
	func load(_ url: JSValue) -> JSValue
}

@objc public class KLContactDatabase: NSObject, KLContactTable, KLTableProtocol, KLTableCoreProtocol
{
	private var mContext: KEContext

	public init(context ctxt: KEContext){
		mContext = ctxt
	}

	public func core() -> CNTable {
		return CNContactDatabase.shared
	}

	public var recordCount: JSValue { get {
		let dc = CNContactDatabase.shared
		return JSValue(int32: Int32(dc.recordCount), in: mContext)
	}}

	public var defaultFields: JSValue { get {
		var result: Dictionary<String, Any> = [:]
		let dc = CNContactDatabase.shared
		for (key, val) in dc.defaultFields {
			result[key] = val.toAny()
		}
		return JSValue(object: result, in: mContext)
	}}

	public func authorize(_ callback: JSValue) {
		let dc = CNContactDatabase.shared
		dc.authorize(callback: {
			(_ granted: Bool) -> Void in
			if let param = JSValue(bool: granted, in: self.mContext) {
				callback.call(withArguments: [param])
			}
		})
	}

	public func load(_ urlp: JSValue) -> JSValue {
		var result = false
		if urlp.isNull {
			let dc = CNContactDatabase.shared
			switch dc.load(fromURL: nil) {
			case .ok:
				result = true
			case .error(let err):
				CNLog(logLevel: .error, message: err.description, atFunction: #function, inFile: #file)
			@unknown default:
				CNLog(logLevel: .error, message: "Unknown case", atFunction: #function, inFile: #file)
			}
		} else if let url = urlp.toURL() {
			let dc = CNContactDatabase.shared
			switch dc.load(fromURL: url) {
			case .ok:
				result = true
			case .error(let err):
				CNLog(logLevel: .error, message: err.description, atFunction: #function, inFile: #file)
			@unknown default:
				CNLog(logLevel: .error, message: "Unknown case", atFunction: #function, inFile: #file)
			}
		}
		return JSValue(bool: result, in: mContext)
	}

	public func newRecord() -> JSValue {
		let recobj = CNContactDatabase.shared.newRecord()
		let newrec = KLRecord(record: recobj, context: mContext)
		if let newval = KLRecord.allocate(record: newrec) {
			return newval
		} else {
			CNLog(logLevel: .error, message: "Failed to allocate", atFunction: #function, inFile: #file)
			return JSValue(nullIn: mContext)
		}
	}

	public func record(_ rowp: JSValue) -> JSValue {
		if rowp.isNumber {
			let dc  = CNContactDatabase.shared
			let row = rowp.toInt32()
			if let rec = dc.record(at: Int(row)) {
				let newrec = KLRecord(record: rec, context: mContext)
				if let newval = KLRecord.allocate(record: newrec) {
					return newval
				} else {
					CNLog(logLevel: .error, message: "Failed to allocate", atFunction: #function, inFile: #file)
				}
			}
		}
		return JSValue(nullIn: mContext)
	}

	public func pointer(_ val: JSValue, _ field: JSValue) -> JSValue {
		CNLog(logLevel: .error, message: "Not supported", atFunction: #function, inFile: #file)
		return JSValue(nullIn: mContext)
	}

	public func search(_ val: JSValue, _ field: JSValue) -> JSValue {
		let db  = CNContactDatabase.shared
		if field.isString {
			if let fname = field.toString() {
				let nval = val.toNativeValue()
				let recs = db.search(value: nval, forField: fname)
				let objs = recs.map({(_ rec: CNRecord) -> KLRecord in return KLRecord(record: rec, context: mContext)})
				if let res = KLRecord.allocate(records: objs, context: mContext) {
					return res
				} else {
					CNLog(logLevel: .error, message: "Failed to allocate", atFunction: #function, inFile: #file)
				}
			}
		}
		return JSValue(nullIn: mContext)
	}

	public func append(_ rcdp: JSValue) {
		if rcdp.isObject {
			if let rec = rcdp.toObject() as? KLRecord {
				let dc  = CNContactDatabase.shared
				dc.append(record: rec.core())
				return
			}
		}
		CNLog(logLevel: .error, message: "Unexpected record object", atFunction: #function, inFile: #file)
	}

	public func appendPointer(_ ptr: JSValue) {
		CNLog(logLevel: .error, message: "Not supported", atFunction: #function, inFile: #file)
	}

	public func remove(_ rcd: JSValue) -> JSValue {
		CNLog(logLevel: .error, message: "Not supported yet", atFunction: #function, inFile: #file)
		return JSValue(bool: false, in: mContext)
	}

	public func save() -> JSValue {
		CNLog(logLevel: .error, message: "Not supported yet", atFunction: #function, inFile: #file)
		return JSValue(bool: false, in: mContext)
	}

	public func forEach(_ callback: JSValue) {
		let db = CNContactDatabase.shared
		db.forEach(callback: {
			(_ record: CNRecord) -> Void in
			let recobj = KLRecord(record: record, context: mContext)
			if let recval = KLRecord.allocate(record: recobj) {
				callback.call(withArguments: [recval])
			} else {
				CNLog(logLevel: .error, message: "Failed to allocate", atFunction: #function, inFile: #file)
			}
		})
	}

	public func toString() -> JSValue {
		return JSValue(object: "{Not supported}", in: mContext)
	}
}


