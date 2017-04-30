/**
 * @file	KSState.swift
 * @brief	Define KSState class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation
import Canary

public struct KSStateInitialValue {
	var key:	NSString
	var value:	CNValue

	public init(key k:NSString, value v:CNValue){
		key = k ; value = v
	}
}

public class KCValueObject
{
	public var value: CNValue

	public init(value val: CNValue){
		value = val
	}
}

@objc open class KSState: NSObject
{
	/// Dictionary: Key: String, Value: CNValueObject
	private var mDictionary : NSMutableDictionary = NSMutableDictionary(capacity: 16)


	public func setInitialValues(initialValues initvals: Array<KSStateInitialValue>){
		for initval in initvals {
			let key   = initval.key
			let value = KCValueObject(value: initval.value)
			mDictionary.setObject(value, forKey: key)
		}
	}

	public func setObserver(observer obs: NSObject){
		let keys = mDictionary.allKeys
		for key in keys {
			if let keystr = key as? NSString {
				mDictionary.addObserver(obs, forKeyPath: String(keystr), options: .new, context: nil)
			} else {
				fatalError("Not string")
			}
		}
	}

	public func member(forKey key: NSString) -> CNValue {
		if let o = mDictionary.object(forKey: key) {
			if let v = o as? KCValueObject {
				return v.value
			}
		}
		fatalError("No object")
	}

	public func setMember(value val: CNValue, forKey key: NSString) {
		let valobj = KCValueObject(value: val)
		mDictionary.setObject(valobj, forKey: key)
	}
}



