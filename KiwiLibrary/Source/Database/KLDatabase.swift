/**
 * @file	KLDatabase.swift
 * @brief	Define KLDatabase class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

@objc public protocol KLDatabaseProtocol: JSExport
{
	func read(_ ident: JSValue) -> JSValue
	func write(_ ident: JSValue, _ value: JSValue) -> JSValue
	func delete(_ ident: JSValue) -> JSValue
	func commit() -> Void
}

@objc public class KLDatabase: NSObject, KLDatabaseProtocol
{
	private var mDatabase: CNDatabaseProtocol
	private var mContext:  KEContext

	public init(database db: CNDatabaseProtocol, context ctxt: KEContext) {
		mDatabase = db
		mContext  = ctxt
	}

	public func read(_ identval: JSValue) -> JSValue {
		/* Check parameters */
		guard let identifier = valueToIdentifier(value: identval) else {
			return JSValue(undefinedIn: mContext)
		}
		/* Call database */
		let retval: JSValue
		if let natval = mDatabase.read(identifier: identifier) {
			retval = natval.toJSValue(context: mContext)
		} else {
			retval = JSValue(undefinedIn: mContext)
		}
		/* Return result */
		return retval
	}

	public func write(_ identval: JSValue, _ val: JSValue) -> JSValue {
		/* Check parameters */
		guard let identifier = valueToIdentifier(value: identval) else {
			return JSValue(bool: false, in: mContext)
		}
		let native = val.toNativeValue()
		/* Call database */
		let _ = mDatabase.write(identifier: identifier, value: native)
		/* Return result */
		return JSValue(bool: true, in: mContext)
	}

	public func delete(_ identval: JSValue) -> JSValue {
		/* Check parameters */
		guard let identifier = valueToIdentifier(value: identval) else {
			return JSValue(bool: false, in: mContext)
		}
		/* Call database */
		mDatabase.delete(identifier: identifier)
		/* Return result */
		return JSValue(bool: true, in: mContext)
	}

	public func commit() {
		mDatabase.commit()
	}
	
	private func valueToIdentifier(value val: JSValue) -> String? {
		if val.isString {
			return val.toString()
		} else {
			return nil
		}
	}
}


