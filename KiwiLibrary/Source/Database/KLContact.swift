/**
 * @file	KLContacts.swift
 * @brief	Extend KLContacts class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiEngine
import Canary
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
	private var mAuthorize:		CNAuthorizeType

	public init(context ctxt: KEContext, console cons: CNConsole){
		mContext      = ctxt
		mConsole      = cons
		mAuthorize    = .Undetermined
	}

	public var status: JSValue {
		get { return JSValue(int32: Int32(mAuthorize.rawValue), in: mContext) }
	}

	public func authorize() -> JSValue {
		requestAuthorize()
		return JSValue(int32: Int32(mAuthorize.rawValue), in: mContext)
	}

	private func requestAuthorize() {
		if mAuthorize == .Undetermined {
			let status = CNContactStore.authorizationStatus(for: .contacts)
			switch status {
			case .authorized:
				mAuthorize = .Authorized
			case .denied:
				mAuthorize = .Denied
			case .notDetermined, .restricted:
				requestAccess()
			}
		}
	}

	private func requestAccess() {
		let store = CNContactStore()
		store.requestAccess(for: .contacts, completionHandler: {
			(_ granted: Bool, _ error: Error?) -> Void in
			if granted {
				self.mAuthorize = .Authorized
			} else {
				self.mAuthorize = .Denied
			}
		})
	}

	public func contacts() -> JSValue
	{
		if let result = allContacts() {
			return JSValue(object: result, in: mContext)
		} else {
			return JSValue(nullIn: mContext)
		}
	}

	public func allContacts() -> Array<Dictionary<String, AnyObject>>? {
		requestAuthorize()
		let store   = CNContactStore()
		let keys    = [CNContactFamilyNameKey as CNKeyDescriptor]
		let request = CNContactFetchRequest(keysToFetch: keys)
		do {
			var result: Array<Dictionary<String, AnyObject>> = []
			try store.enumerateContacts(with: request, usingBlock: {
				(contact, pointer) in
				result.append(KLContact.contactToDictionary(contact: contact))
			})
			return result
		}
		catch {
			return nil
		}
	}

	private class func contactToDictionary(contact cont: CNContact) -> Dictionary<String, AnyObject> {
		var result: Dictionary<String, AnyObject> = [:]
		result["identifier"]  = NSString(string: cont.identifier)
		result["givenName"]   = NSString(string: cont.givenName)
		result["familyName"]  = NSString(string: cont.familyName)
		return result
	}
}

