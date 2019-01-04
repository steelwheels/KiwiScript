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

@objc public class KLDatabase: KEObject
{
	static let 	ReadItem 	= "read"
	static let 	WriteItem	= "write"
	static let	DeleteItem	= "delete"
	static let 	CommitItem	= "commit"

	private var mDatabase: CNDatabaseProtocol

	public init(database db: CNDatabaseProtocol, context ctxt: KEContext) {
		mDatabase = db
		super.init(context: ctxt)
		setup(context: ctxt)
	}

	private func setup(context ctxt: KEContext){
		/* Define: read */
		let readfunc: @convention(block) (_ ident: JSValue) -> JSValue = {
			(_ ident: JSValue) -> JSValue in
			return self.read(identifier: ident)
		}
		set(KLDatabase.ReadItem,  JSValue(object: readfunc, in: ctxt))

		/* Define: write */
		let writefunc: @convention(block) (_ ident: JSValue, _ value: JSValue) -> JSValue = {
			(_ ident: JSValue, _ value: JSValue) -> JSValue in
			return self.write(identifier: ident, value: value)
		}
		set(KLDatabase.WriteItem,  JSValue(object: writefunc, in: ctxt))

		/* Define: delete */
		let deletefunc: @convention(block) (_ ident: JSValue) -> JSValue = {
			(_ ident: JSValue) -> JSValue in
			return self.delete(identifier: ident)
		}
		set(KLDatabase.DeleteItem,  JSValue(object: deletefunc, in: ctxt))

		/* Define: commit */
		let commitfunc: @convention(block) () -> Void = {
			() -> Void in
			self.commit()
		}
		set(KLDatabase.CommitItem,  JSValue(object: commitfunc, in: ctxt))
	}

	public func read(identifier identval: JSValue) -> JSValue {
		/* Check parameters */
		guard let identifier = valueToIdentifier(value: identval) else {
			return JSValue(undefinedIn: self.context)
		}
		/* Call database */
		let retval: JSValue
		if let natval = mDatabase.read(identifier: identifier) {
			retval = natval.toJSValue(context: self.context)
		} else {
			retval = JSValue(undefinedIn: self.context)
		}
		/* Return result */
		return retval
	}

	public func write(identifier identval: JSValue, value val: JSValue) -> JSValue {
		/* Check parameters */
		guard let identifier = valueToIdentifier(value: identval) else {
			return JSValue(bool: false, in: self.context)
		}
		let native = val.toNativeValue()
		/* Call database */
		let _ = mDatabase.write(identifier: identifier, value: native)
		/* Return result */
		return JSValue(bool: true, in: self.context)
	}

	public func delete(identifier identval: JSValue) -> JSValue {
		/* Check parameters */
		guard let identifier = valueToIdentifier(value: identval) else {
			return JSValue(bool: false, in: self.context)
		}
		/* Call database */
		mDatabase.delete(identifier: identifier)
		/* Return result */
		return JSValue(bool: true, in: self.context)
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


