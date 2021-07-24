/**
 * @file	KLAddressBook.swift
 * @brief	Define KLAddressBook class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import CoconutDatabase
import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation

@objc public protocol KLContactRecordProtocol: JSExport
{
	var itemCount: JSValue { get }

	func value(_ prop: JSValue) -> JSValue
	func setValue(_ val: JSValue, _ prop: JSValue)

	var identifier:			JSValue { get }
	var contactType:		JSValue { get }
	var namePrefix:			JSValue { get }
	var givenName:			JSValue { get }
	var middleName:			JSValue { get }
	var familyName:			JSValue { get }
	var previousFamilyName:		JSValue { get }
	var nameSuffix:			JSValue { get }
	var nickname:			JSValue { get }
	var phoneticGivenName:		JSValue { get }
	var phoneticMiddleName:		JSValue { get }
	var phoneticFamilyName:		JSValue { get }
	var jobTitle:			JSValue { get }
	var departmentName:		JSValue { get }
	var organizationName:		JSValue { get }
	var phoneticOrganizationName:	JSValue { get }
	var postalAddresses:		JSValue { get }
	var emailAddresses:		JSValue { get }
	var urlAddresses:		JSValue { get }
	var instantMessageAddresses:	JSValue { get }
	var phoneNumbers:		JSValue { get }
	var birthday:			JSValue { get }
	var nonGregorianBirthday:	JSValue { get }
	var dates:			JSValue { get }
	var note:			JSValue { get }
	var imageData:			JSValue { get }
	var thumbnailImageData:		JSValue { get }
	var imageDataAvailable:		JSValue { get }
	var relations:			JSValue { get }
}

@objc public class KLContactRecord: NSObject, KLContactRecordProtocol
{
	private var mContact:	CNContactRecord
	private var mContext:	KEContext

	public init(contact ctct: CNContactRecord, context ctxt: KEContext){
		mContact	= ctct
		mContext	= ctxt
	}

	public var core: CNContactRecord { get {
		return mContact
	}}

	public var itemCount: JSValue {
		get { return JSValue(int32: Int32(mContact.itemCount), in: mContext) }
	}

	public var identifier: JSValue {
		get { return mContact.identifier.toJSValue(context: mContext) }
	}

	public var contactType: JSValue {
		get { return mContact.contactType.toJSValue(context: mContext) }
	}

	public var namePrefix: JSValue {
		get { return mContact.namePrefix.toJSValue(context: mContext) }
	}

	public var givenName: JSValue {
		get { return mContact.givenName.toJSValue(context: mContext) }
	}

	public var middleName: JSValue {
		get { return mContact.middleName.toJSValue(context: mContext) }
	}

	public var familyName: JSValue {
		get { return mContact.familyName.toJSValue(context: mContext) }
	}

	public var previousFamilyName: JSValue {
		get { return mContact.previousFamilyName.toJSValue(context: mContext) }
	}

	public var nameSuffix: JSValue {
		get { return mContact.nameSuffix.toJSValue(context: mContext) }
	}

	public var nickname: JSValue {
		get { return mContact.nickname.toJSValue(context: mContext) }
	}

	public var phoneticGivenName: JSValue {
		get { return mContact.phoneticGivenName.toJSValue(context: mContext) }
	}

	public var phoneticMiddleName: JSValue {
		get { return mContact.phoneticMiddleName.toJSValue(context: mContext) }
	}

	public var phoneticFamilyName: JSValue {
		get { return mContact.phoneticFamilyName.toJSValue(context: mContext) }
	}

	public var jobTitle: JSValue {
		get { return mContact.jobTitle.toJSValue(context: mContext) }
	}

	public var departmentName: JSValue {
		get { return mContact.departmentName.toJSValue(context: mContext) }
	}

	public var organizationName: JSValue {
		get { return mContact.organizationName.toJSValue(context: mContext) }
	}

	public var phoneticOrganizationName: JSValue {
		get { return mContact.phoneticOrganizationName.toJSValue(context: mContext) }
	}

	public var postalAddresses: JSValue {
		get { return mContact.postalAddresses.toJSValue(context: mContext) }
	}

	public var emailAddresses: JSValue {
		get { return mContact.emailAddresses.toJSValue(context: mContext) }
	}

	public var urlAddresses: JSValue {
		get { return mContact.urlAddresses.toJSValue(context: mContext) }
	}

	public var instantMessageAddresses: JSValue {
		get { return mContact.instantMessageAddresses.toJSValue(context: mContext) }
	}

	public var phoneNumbers: JSValue {
		get { return mContact.phoneNumbers.toJSValue(context: mContext) }
	}

	public var birthday: JSValue {
		get { return mContact.birthday.toJSValue(context: mContext) }
	}

	public var nonGregorianBirthday: JSValue {
		get { return mContact.nonGregorianBirthday.toJSValue(context: mContext) }
	}

	public var dates: JSValue {
		get { return mContact.dates.toJSValue(context: mContext) }
	}

	public var note: JSValue {
		get { return mContact.note.toJSValue(context: mContext) }
	}

	public var imageData: JSValue {
		get { return mContact.imageData.toJSValue(context: mContext) }
	}

	public var thumbnailImageData: JSValue {
		get { return mContact.thumbnailImageData.toJSValue(context: mContext) }
	}

	public var imageDataAvailable: JSValue {
		get { return mContact.imageDataAvailable.toJSValue(context: mContext) }
	}

	public var relations: JSValue {
		get { return mContact.relations.toJSValue(context: mContext) }
	}

	public func value(_ propval: JSValue) -> JSValue {
		if let prop = valueToProperty(propertyValue: propval) {
			let val = mContact.value(forProperty: prop)
			return val.toJSValue(context: mContext)
		}
		return JSValue(nullIn: mContext)
	}

	public func setValue(_ val: JSValue, _ propval: JSValue){
		if let prop = valueToProperty(propertyValue: propval) {
			let nval = val.toNativeValue()
			mContact.setValue(value: nval, byProperty: prop)
		}
	}

	private func valueToProperty(propertyValue pval: JSValue) -> CNContactRecord.Property? {
		if pval.isNumber {
			if let prop = CNContactRecord.Property(rawValue: Int(pval.toInt32())) {
				return prop
			}
		} else if pval.isString {
			if let prop = CNContactRecord.stringToProperty(name: pval.toString()) {
				return prop
			}
		}
		return nil
	}
}

