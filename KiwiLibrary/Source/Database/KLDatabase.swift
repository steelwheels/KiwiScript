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
	func create(_ identifier: JSValue, _ value: JSValue) -> JSValue // Bool
	func read(_ identifier: JSValue) -> JSValue // Object
	func write(_ identifier: JSValue, _ value: JSValue) -> JSValue // Bool
	func delete(_ identifier: JSValue) -> JSValue // Object or undefined
	func commit()
}

@objc public class KLDatabase: NSObject, KLDatabaseProtocol
{
	private var mDatabase:	CNDatabase
	private var mContext:	KEContext

	public init(database db: CNDatabase, context ctxt: KEContext){
		mDatabase = db
		mContext  = ctxt
	}

	public func create(_ identval: JSValue, _ value: JSValue) -> JSValue {
		/* Check parameters */
		guard let identifier = valueToIdentifier(value: identval) else {
			return JSValue(nullIn: mContext)
		}
		let native = value.toNativeValue()

		/* Call database */
		let result = mDatabase.create(identifier: identifier, value: native)
		/* Return result */
		return JSValue(bool: result, in: mContext)
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

	public func write(_ identval: JSValue, _ value: JSValue) -> JSValue {
		/* Check parameters */
		guard let identifier = valueToIdentifier(value: identval) else {
			return JSValue(nullIn: mContext)
		}
		let native = value.toNativeValue()
		/* Call database */
		let result = mDatabase.write(identifier: identifier, value: native)
		/* Return result */
		return JSValue(bool: result, in: mContext)
	}

	public func delete(_ identval: JSValue) -> JSValue {
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

