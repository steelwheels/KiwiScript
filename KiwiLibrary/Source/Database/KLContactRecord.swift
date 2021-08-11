/**
 * @file	KLContactRecord.swift
 * @brief	Define KLContactRecord class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import CoconutDatabase
import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation

@objc public protocol KLRecord: JSExport
{
	var fieldCount: JSValue { get }
	var fieldNames: JSValue { get }

	func value(_ name: JSValue) -> JSValue
	func setValue(_ val: JSValue, _ name: JSValue) -> JSValue

	func save()
	func dumpToValue() -> JSValue
}

public protocol KLRecordCore
{
	func core() -> CNRecord
}

@objc public protocol KLContactRecordProtocol: JSExport
{
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

@objc public class KLContactRecord: NSObject, KLRecord, KLRecordCore, KLContactRecordProtocol
{
	private var mContact:	CNContactRecord
	private var mContext:	KEContext

	public init(contact ctct: CNContactRecord, context ctxt: KEContext){
		mContact	= ctct
		mContext	= ctxt
	}

	public func core() -> CNRecord {
		return mContact
	}

	public var fieldCount: JSValue { get {
		return JSValue(int32: Int32(mContact.fieldCount), in: mContext)
	}}

	public var fieldNames: JSValue { get {
		return JSValue(object: mContact.fieldNames, in: mContext)
	}}

	private func value(ofField fld: CNContactField) -> JSValue {
		if let val = mContact.value(ofField: fld.toName()) {
			return val.toJSValue(context: mContext)
		} else {
			return JSValue(nullIn: mContext)
		}
	}

	private func value(ofFieldName name: String) -> JSValue {
		if let val = mContact.value(ofField: name) {
			return val.toJSValue(context: mContext)
		} else {
			return JSValue(nullIn: mContext)
		}
	}

	public func value(_ name: JSValue) -> JSValue {
		if let str = name.toString() {
			return value(ofFieldName: str)
		} else {
			return JSValue(nullIn: mContext)
		}
	}

	private func setValue(value val: JSValue, forField fld: CNContactField) {
		let _ = mContact.setValue(value: val.toNativeValue(), forField: fld.toName())
	}

	private func setValue(value val: CNNativeValue, forFieldName name: String) -> JSValue {
		let res = mContact.setValue(value: val, forField: name)
		return JSValue(bool: res, in: mContext)
	}

	public func setValue(_ val: JSValue, _ name: JSValue) -> JSValue {
		if let str = name.toString() {
			return setValue(value: val.toNativeValue(), forFieldName: str)
		} else {
			return JSValue(bool: false, in: mContext)
		}
	}

	public func save() {
		// not supported
	}

	public func dumpToValue() -> JSValue {
		let nval = mContact.toNativeValue()
		return nval.toJSValue(context: mContext)
	}

	public var identifier: JSValue {
		get      { return value(ofField: .identifier)}
		set(val) { setValue(value: val, forField: .identifier)}
	}

	public var contactType: JSValue {
		get      { return value(ofField: .contactType)}
		set(val) { setValue(value: val, forField: .contactType)}
	}

	public var namePrefix: JSValue {
		get      { return value(ofField: .namePrefix)}
		set(val) { setValue(value: val, forField: .namePrefix)}
	}

	public var givenName: JSValue {
		get      { return value(ofField: .givenName)}
		set(val) { setValue(value: val, forField: .givenName)}
	}

	public var middleName: JSValue {
		get      { return value(ofField: .middleName)}
		set(val) { setValue(value: val, forField: .middleName)}
	}

	public var familyName: JSValue {
		get      { return value(ofField: .familyName)}
		set(val) { setValue(value: val, forField: .familyName)}
	}

	public var previousFamilyName: JSValue {
		get      { return value(ofField: .previousFamilyName)}
		set(val) { setValue(value: val, forField: .previousFamilyName)}
	}

	public var nameSuffix: JSValue {
		get      { return value(ofField: .nameSuffix)}
		set(val) { setValue(value: val, forField: .nameSuffix)}
	}

	public var nickname: JSValue {
		get      { return value(ofField: .nickname)}
		set(val) { setValue(value: val, forField: .nickname)}
	}

	public var phoneticGivenName: JSValue {
		get      { return value(ofField: .phoneticGivenName)}
		set(val) { setValue(value: val, forField: .phoneticGivenName)}
	}

	public var phoneticMiddleName: JSValue {
		get      { return value(ofField: .phoneticMiddleName)}
		set(val) { setValue(value: val, forField: .phoneticMiddleName)}
	}

	public var phoneticFamilyName: JSValue {
		get      { return value(ofField: .phoneticFamilyName)}
		set(val) { setValue(value: val, forField: .phoneticFamilyName)}
	}

	public var jobTitle: JSValue {
		get      { return value(ofField: .jobTitle)}
		set(val) { setValue(value: val, forField: .jobTitle)}
	}

	public var departmentName: JSValue {
		get      { return value(ofField: .departmentName)}
		set(val) { setValue(value: val, forField: .departmentName)}
	}

	public var organizationName: JSValue {
		get      { return value(ofField: .organizationName)}
		set(val) { setValue(value: val, forField: .organizationName)}
	}

	public var phoneticOrganizationName: JSValue {
		get      { return value(ofField: .phoneticOrganizationName)}
		set(val) { setValue(value: val, forField: .phoneticOrganizationName)}
	}

	public var postalAddresses: JSValue {
		get      { return value(ofField: .postalAddresses)}
		set(val) { setValue(value: val, forField: .postalAddresses)}
	}

	public var emailAddresses: JSValue {
		get      { return value(ofField: .emailAddresses)}
		set(val) { setValue(value: val, forField: .emailAddresses)}
	}

	public var urlAddresses: JSValue {
		get      { return value(ofField: .urlAddresses)}
		set(val) { setValue(value: val, forField: .urlAddresses)}
	}

	public var instantMessageAddresses: JSValue {
		get      { return value(ofField: .instantMessageAddresses)}
		set(val) { setValue(value: val, forField: .instantMessageAddresses)}
	}

	public var phoneNumbers: JSValue {
		get      { return value(ofField: .phoneNumbers)}
		set(val) { setValue(value: val, forField: .phoneNumbers)}
	}

	public var birthday: JSValue {
		get      { return value(ofField: .birthday)}
		set(val) { setValue(value: val, forField: .birthday)}
	}

	public var nonGregorianBirthday: JSValue {
		get      { return value(ofField: .nonGregorianBirthday)}
		set(val) { setValue(value: val, forField: .nonGregorianBirthday)}
	}

	public var dates: JSValue {
		get      { return value(ofField: .dates)}
		set(val) { setValue(value: val, forField: .dates)}
	}

	public var note: JSValue {
		get      { return value(ofField: .note)}
		set(val) { setValue(value: val, forField: .note)}
	}

	public var imageData: JSValue {
		get      { return value(ofField: .imageData)}
		set(val) { setValue(value: val, forField: .imageData)}
	}

	public var thumbnailImageData: JSValue {
		get      { return value(ofField: .thumbnailImageData)}
		set(val) { setValue(value: val, forField: .thumbnailImageData)}
	}

	public var imageDataAvailable: JSValue {
		get      { return value(ofField: .imageDataAvailable)}
		set(val) { setValue(value: val, forField: .imageDataAvailable)}
	}

	public var relations: JSValue {
		get      { return value(ofField: .relations)}
		set(val) { setValue(value: val, forField: .relations)}
	}
}

