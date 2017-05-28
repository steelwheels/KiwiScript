/**
 * @file	KEValue.swift
 * @brief	Function to operate JSValue
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Canary
import JavaScriptCore
import Foundation

public class KEPropertyTable
{
	private var mContext	: JSContext
	private var mTable	: NSMutableDictionary
	private var mObservers	: Array<NSObject>

	public init(context ctxt: JSContext){
		mContext   = ctxt
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
	
	public func addObserver(observer obs: NSObject, propertyNames names: Array<String>)
	{
		for key in names {
			mTable.addObserver(obs, forKeyPath: key, options: .new, context: nil)
			mObservers.append(obs)
		}
	}

	public func setValue(identifier ident: String, any val: JSValue){
		mTable.setValue(val, forKey: ident)
	}

	public func value(identifier ident: String) -> JSValue? {
		if let val = mTable.value(forKey: ident) as? JSValue {
			return val
		}
		return nil
	}

	public func setBooleanValue(identifier ident:String, bool val: Bool){
		let obj = JSValue(bool: val, in: mContext)
		mTable.setValue(obj, forKey: ident)
	}

	public func booleanValue(identifier ident: String) -> Bool? {
		if let val = mTable.value(forKey: ident) as? JSValue {
			if val.isBoolean {
				return val.toBool()
			} else {
				NSLog("Invalid data type")
			}
		}
		return nil
	}

	public func setIntValue(identifier ident:String, int val: Int32){
		let obj = JSValue(int32: val, in: mContext)
		mTable.setValue(obj, forKey: ident)
	}

	public func intValue(identifier ident: String) -> Int32? {
		if let val = mTable.value(forKey: ident) as? JSValue {
			if val.isNumber {
				return val.toInt32()
			} else {
				NSLog("Invalid data type")
			}
		}
		return nil
	}

	public func setUIntValue(identifier ident:String, uInt val: UInt32){
		let obj = JSValue(uInt32: val, in: mContext)
		mTable.setValue(obj, forKey: ident)
	}

	public func uIntValue(identifier ident: String) -> UInt32? {
		if let val = mTable.value(forKey: ident) as? JSValue {
			if val.isNumber {
				return val.toUInt32()
			} else {
				NSLog("Invalid data type")
			}
		}
		return nil
	}

	public func setDoubleValue(identifier ident:String, double val: Double){
		let obj = JSValue(double: val, in: mContext)
		mTable.setValue(obj, forKey: ident)
	}

	public func doubleValue(identifier ident: String) -> Double? {
		if let val = mTable.value(forKey: ident) as? JSValue {
			if val.isNumber {
				return val.toDouble()
			} else {
				NSLog("Invalid data type")
			}
		}
		return nil
	}

	public func setStringValue(identifier ident:String, string val: String){
		let obj = JSValue(object: val, in: mContext)
		mTable.setValue(obj, forKey: ident)
	}

	public func stringValue(identifier ident: String) -> String? {
		if let val = mTable.value(forKey: ident) as? JSValue {
			if val.isString {
				return val.toString()
			} else {
				NSLog("Invalid data type")
			}
		}
		return nil
	}

	public func setArrayValue(identifier ident:String, array val: Array<Any>){
		let obj = JSValue(object: val, in: mContext)
		mTable.setValue(obj, forKey: ident)
	}

	public func arrayValue(identifier ident: String) -> Array<Any>? {
		if let val = mTable.value(forKey: ident) as? JSValue {
			if val.isArray {
				return val.toArray()
			} else {
				NSLog("Invalid data type")
			}
		}
		return nil
	}
}
