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

@objc open class KSState: NSObject
{
	public enum KSStateError {
		case NoError
		case DifferentTypeError
		case UnknownTypeError

		public func description() -> String {
			let result: String
			switch self {
			case .NoError:			result = ""
			case .DifferentTypeError:	result = "The type of new value is different from current one"
			case .UnknownTypeError:		result = "The current value type is NOT known"
			}
			return result
		}
	}

	/// Dictionary: Key: String, Value: CNValue
	private var mDictionary : NSMutableDictionary = NSMutableDictionary(capacity: 16)

	public func setInitialValues(initialValues initvals: Array<KSStateInitialValue>){
		for initval in initvals {
			mDictionary.setObject(initval.value, forKey: initval.key)
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

	public func member(forKey key: NSString) -> CNValue? {
		if let obj = mDictionary.object(forKey: key) {
			if let val = obj as? CNValue {
				return val
			}
		}
		return nil
	}

	public func setMember(value val: CNValue, forKey key: NSString) -> KSStateError {
		if let curobj = mDictionary.object(forKey: key) {
			if let curval = curobj as? CNValue {
				if curval.type != val.type {
					return .DifferentTypeError
				}
			} else {
				return .UnknownTypeError
			}
		}
		mDictionary.setObject(val, forKey: key)
		return .NoError
	}
}



