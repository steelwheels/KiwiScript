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

@objc public protocol KLTable: JSExport
{
	var recordCount: JSValue { get }

	func authorize(_ callback: JSValue)
	func load(_ url: JSValue) -> JSValue

	func newRecord() -> JSValue
	func record(_ row: JSValue) -> JSValue
	func append(_ rcd: JSValue)
	func forEach(_ callback: JSValue)

	func save()
	func dumpToValue() -> JSValue
}

public protocol KLTableCore
{
	func core() -> CNTable
}

@objc public class KLContactDatabase: NSObject, KLTable, KLTableCore
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
			switch dc.load(URL: nil) {
			case .ok:
				result = true
			case .error(let err):
				CNLog(logLevel: .error, message: err.description, atFunction: #function, inFile: #file)
			@unknown default:
				CNLog(logLevel: .error, message: "Unknown case", atFunction: #function, inFile: #file)
			}
		} else if urlp.isURL {
			let dc = CNContactDatabase.shared
			switch dc.load(URL: urlp.toURL()) {
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
		let dc     = CNContactDatabase.shared
		if let core   = dc.newRecord() as? CNContactRecord {
			let newrec = KLContactRecord(contact: core, context: mContext)
			return JSValue(object: newrec, in: mContext)
		} else {
			CNLog(logLevel: .error, message: "Unexpected record type", atFunction: #function, inFile: #file)
			return JSValue(nullIn: mContext)
		}
	}

	public func record(_ rowp: JSValue) -> JSValue {
		if rowp.isNumber {
			let dc  = CNContactDatabase.shared
			let row = rowp.toInt32()
			if let rec = dc.record(at: Int(row)) {
				if let crec = rec as? CNContactRecord {
					let newrec = KLContactRecord(contact: crec, context: mContext)
					return JSValue(object: newrec, in: mContext)
				} else {
					CNLog(logLevel: .error, message: "Unexpected record object", atFunction: #function, inFile: #file)
				}
			}
		}
		return JSValue(nullIn: mContext)
	}

	public func append(_ rcdp: JSValue) {
		if rcdp.isObject {
			if let rec = rcdp.toObject() as? KLContactRecord {
				let dc  = CNContactDatabase.shared
				dc.append(record: rec.core())
				return
			}
		}
		CNLog(logLevel: .error, message: "Unexpected record object", atFunction: #function, inFile: #file)

	}

	public func forEach(_ callback: JSValue) {
		let db = CNContactDatabase.shared
		db.forEach(callback: {
			(_ record: CNRecord) -> Void in
			if let crec = record as? CNContactRecord {
				let recobj = KLContactRecord(contact: crec, context: mContext)
				callback.call(withArguments: [recobj])
			} else {
				CNLog(logLevel: .error, message: "Unexpected record object", atFunction: #function, inFile: #file)
			}
		})
	}

	public func save() {
		let dc  = CNContactDatabase.shared
		dc.save()
	}

	public func dumpToValue() -> JSValue {
		let dc   = CNContactDatabase.shared
		let nval = dc.toNativeValue()
		return nval.toJSValue(context: mContext)
	}
}

/*
@objc public class KLContactDatabase: NSObject, KLContactDatabaseProtocol
{
	private var mContext: KEContext

	public init(context ctxt: KEContext){
		mContext = ctxt
		super.init()
	}

	public func load(_ callback: JSValue){
		let db = CNContactDatabase.shared
		db.authorize(callback: {
			(_ granted: Bool) -> Void in
			let result: Bool
			if granted {
				result = db.load()
			} else {
				result = false
			}
			if !callback.isNull {
				if let retval = JSValue(bool: result, in:  self.mContext) {
					callback.call(withArguments: [retval])
				} else {
					NSLog("[Error] Failed to allocate JSValue object")
				}
			}
		})
	}

	public var recordCount: JSValue { get {
		let db = CNContactDatabase.shared
		return JSValue(int32: Int32(db.recordCount), in: mContext)
	}}

	public func record(_ index: JSValue) -> JSValue {
		if index.isNumber {
			let i  = Int(index.toInt32())
			let db = CNContactDatabase.shared
			if let rec = db.record(at: i) {
				let recobj = KLContactRecord(contact: rec, context: mContext)
				return JSValue(object: recobj, in: mContext)
			}
		}
		return JSValue(nullIn: mContext)
	}

	public func append(_ record: JSValue) {
		if record.isObject {
			if let recobj = record.toObject() as? KLContactRecord {
				let db = CNContactDatabase.shared
				db.append(record: recobj.core)
				return
			}
		}
		CNLog(logLevel: .error, message: "Failed to append record", atFunction: #function, inFile: #file)
	}

	public func forEach(_ callback: JSValue) {
		let db = CNContactDatabase.shared
		db.forEach(callback: {
			(_ record: CNContactRecord) -> Void in
			let recobj = KLContactRecord(contact: record, context: mContext)
			callback.call(withArguments: [recobj])
		})
	}
}

*/

