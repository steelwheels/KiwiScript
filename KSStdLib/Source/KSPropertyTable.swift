/*
 * @file	KSPropertyTable.swift
 * @brief	Define KSPropertyTable class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Canary
import Foundation

public enum KSPropertyError: Error {
	case NoError
	case MismatchTypeError

	public var description: String {
		var result: String
		switch self {
		case .NoError:			result = "NoError"
		case .MismatchTypeError:	result = "MismatchTypeError"
		}
		return result
	}
}

public class KSPropertyTable
{
	private var mTable	: NSMutableDictionary
	private var mObservers	: Array<NSObject>

	public init(){
		mTable     = NSMutableDictionary(capacity: 16)
		mObservers = []
	}

	deinit {
		for obs in mObservers {
			let keys = mTable.allKeys
			for key in keys {
				if let keystr = key as? String {
					mTable.removeObserver(obs, forKeyPath: keystr)
				} else {
					NSLog("Error: Invalid key object")
				}
			}
		}
	}

	public var table: NSDictionary {
		get { return mTable }
	}

	public func addPropertyObserver(observer obs: NSObject, propertyNames names: Array<String>)
	{
		for key in names {
			mTable.addObserver(obs, forKeyPath: key, options: .new, context: nil)
			mObservers.append(obs)
		}
	}

	public func setBooleanProperty(identifier ident: String, value val: Bool) -> KSPropertyError
	{
		let err = checkNumberKind(identifier: ident, numberKind: .booleanNumber)
		if err == .NoError {
			let valobj = NSNumber(booleanLiteral: val)
			mTable.setValue(valobj, forKey: ident)
			return .NoError
		} else {
			return err
		}
	}

	public func booleanProperty(identifier ident: String) -> Bool?
	{
		if let curobj = mTable.value(forKey: ident) {
			if let curnum = curobj as? NSNumber {
				if curnum.kind == .booleanNumber {
					return curnum.boolValue
				}
			}
		}
		return nil
	}

	public func setIntProperty(identifier ident: String, value val: Int64) -> KSPropertyError
	{
		let err = checkNumberKind(identifier: ident, numberKind: .int64Number)
		if err == .NoError {
			let valobj = NSNumber(value: val)
			mTable.setValue(valobj, forKey: ident)
			return .NoError
		} else {
			return err
		}
	}

	public func intProperty(identifier ident: String) -> Int64?
	{
		if let curobj = mTable.value(forKey: ident) {
			if let curnum = curobj as? NSNumber {
				if curnum.kind == .int64Number {
					return curnum.int64Value
				}
			}
		}
		return nil
	}

	public func setUIntProperty(identifier ident: String, value val: UInt64) -> KSPropertyError
	{
		let err = checkNumberKind(identifier: ident, numberKind: .uInt64Number)
		if err == .NoError {
			let valobj = NSNumber(value: UInt64(val))
			mTable.setValue(valobj, forKey: ident)
			return .NoError
		} else {
			return err
		}
	}

	public func uIntProperty(identifier ident: String) -> UInt64?
	{
		if let curobj = mTable.value(forKey: ident) {
			if let curnum = curobj as? NSNumber {
				if curnum.kind == .int64Number { // Could not use uInt64Number
					return curnum.uint64Value
				}
			}
		}
		return nil
	}

	public func setFloatProperty(identifier ident: String, value val: Float) -> KSPropertyError
	{
		let err = checkNumberKind(identifier: ident, numberKind: .floatNumber)
		if err == .NoError {
			let valobj = NSNumber(value: val)
			mTable.setValue(valobj, forKey: ident)
			return .NoError
		} else {
			return err
		}
	}

	public func floatProperty(identifier ident: String) -> Float?
	{
		if let curobj = mTable.value(forKey: ident) {
			if let curnum = curobj as? NSNumber {
				if curnum.kind == .floatNumber {
					return curnum.floatValue
				}
			}
		}
		return nil
	}

	public func setDoubleProperty(identifier ident: String, value val: Double) -> KSPropertyError
	{
		let err = checkNumberKind(identifier: ident, numberKind: .doubleNumber)
		if err == .NoError {
			let valobj = NSNumber(value: val)
			mTable.setValue(valobj, forKey: ident)
			return .NoError
		} else {
			return err
		}
	}

	public func doubleProperty(identifier ident: String) -> Double?
	{
		if let curobj = mTable.value(forKey: ident) {
			if let curnum = curobj as? NSNumber {
				if curnum.kind == .doubleNumber {
					return curnum.doubleValue
				}
			}
		}
		return nil
	}

	private func checkNumberKind(identifier ident: String, numberKind kind: NSNumberKind) -> KSPropertyError {
		if let curobj = mTable.value(forKey: ident) {
			if let curnum = curobj as? NSNumber {
				if curnum.kind != kind {
					return .MismatchTypeError
				}
			} else {
				return .MismatchTypeError
			}
		}
		return .NoError
	}

	public func setStringProperty(identifier ident: String, value val: NSString) -> KSPropertyError
	{
		if let curobj = mTable.value(forKey: ident) {
			if curobj as? NSString == nil {
				return .MismatchTypeError
			}
		}
		mTable.setValue(val, forKey: ident)
		return .NoError
	}

	public func stringProperty(identifier ident: String) -> NSString? {
		if let curobj = mTable.value(forKey: ident) {
			if let curstr = curobj as? NSString {
				return curstr
			}
		}
		return nil
	}

	public func setDictionaryProperty(identifier ident: String, value val: NSDictionary) -> KSPropertyError
	{
		if let curobj = mTable.value(forKey: ident) {
			if curobj as? NSDictionary == nil {
				return .MismatchTypeError
			}
		}
		mTable.setValue(val, forKey: ident)
		return .NoError
	}

	public func dictionaryProperty(identifier ident: String) -> NSDictionary? {
		if let curobj = mTable.value(forKey: ident) {
			if let curdict = curobj as? NSDictionary {
				return curdict
			}
		}
		return nil
	}
}
