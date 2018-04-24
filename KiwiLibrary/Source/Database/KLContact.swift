/**
 * @file	KLContacts.swift
 * @brief	Extend KLContacts class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import CoconutDatabase
import JavaScriptCore
import Contacts

@objc public protocol KLContactProtocol: JSExport
{
	var status: JSValue { get }		// CNAuthorizeType

	func authorize() -> JSValue		// CNAuthorizeType
	func contacts() -> JSValue		// Array<CNContact>
}

public class KLContact: NSObject, KLContactProtocol
{
	private var mContext:		KEContext
	private var mConsole:		CNConsole
	private var mAddressBook:	CNAddressBook

	public init(context ctxt: KEContext, console cons: CNConsole){
		mContext      = ctxt
		mConsole      = cons
		mAddressBook  = CNAddressBook()
	}

	public var status: JSValue {
		get { return JSValue(int32: Int32(mAddressBook.state.rawValue), in: mContext) }
	}

	public func authorize() -> JSValue {
		return JSValue(int32: Int32(mAddressBook.state.rawValue), in: mContext)
	}

	public func contacts() -> JSValue
	{
		if let contacts = mAddressBook.contacts() {
			return JSValue(object: contacts, in: mContext)
		} else {
			return JSValue(nullIn: mContext)
		}
	}
}

