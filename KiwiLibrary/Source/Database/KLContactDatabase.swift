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

@objc public protocol KLContactDatabaseProtocol: JSExport
{
	var recordCount: JSValue { get }

	func record(_ index: JSValue) -> JSValue
	func append(_ record: JSValue)

	/* callback: (_ granted: Bool) -> Void */
	func load(_ callback: JSValue)
	func forEach(_ callback: JSValue)
}

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

