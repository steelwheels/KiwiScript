/**
 * @file	KMObject.swift
 * @brief	Define KMObject protocol
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation

public enum KMObjectValue
{
	case Object(KMObject)
	case Function(KMFunction)

	func toObject() -> KMObject? {
		switch self {
		case .Object(let obj):		return obj
		case .Function(_):		return nil
		}
	}

	func toFunction() -> KMFunction? {
		switch self {
		case .Object(_):		return nil
		case .Function(let fnc):	return fnc
		}
	}
}

public protocol KMObject
{
	var context:			KEContext { get }
	var modelName:			String { get }
	var instanceName: 		String { get }
	var propertyTable: 		KEObject { get }
	var objectTable:		KMObjectTable { get }

	func set(name nm: String, object obj: KMObjectValue)
}

public class KMObjectTable
{
	private var mObjectTable:	Dictionary<String, KMObjectValue>

	public init(){
		mObjectTable = [:]
	}

	public var objectNames: Array<String> {
		get { return Array(mObjectTable.keys) }
	}

	public func set(name nm: String, object obj: KMObjectValue){
		mObjectTable[nm] = obj
	}

	public func object(name nm: String) -> KMObjectValue? {
		return mObjectTable[nm]
	}
}

open class KMDefaultObject: NSObject, KMObject
{
	private var mContext:		KEContext
	private var mInstanceName:	String
	private var mPropertyTable:	KEObject
	private var mObjectTable:	KMObjectTable

	public var context: 		KEContext { get { return mContext } }
	public var modelName:		String { get { return "Object" }}
	public var instanceName: 	String { get { return mInstanceName }}
	public var propertyTable: 	KEObject { get { return mPropertyTable }}
	public var objectTable:		KMObjectTable { get { return mObjectTable }}

	public init(instanceName iname: String, context ctxt: KEContext){
		mContext	= ctxt
		mInstanceName	= iname
		mPropertyTable	= KEObject(context: ctxt)
		mObjectTable	= KMObjectTable()
	}

	public func set(name nm: String, object obj: KMObjectValue){
		mObjectTable.set(name: nm, object: obj)
		switch obj {
		case .Object(let obj):
			if let prop = JSValue(object: obj.propertyTable, in: context) {
				propertyTable.set(nm, prop)
			} else {
				NSLog("Failed to allocate value")
			}
		case .Function(let obj):
			propertyTable.set(nm, obj.functionObject)
			break
		}
	}
}

extension KMObject
{
	public var propertyNames: Array<String> {
		return propertyTable.propertyNames
	}

	public var objectNames: Array<String> {
		return objectTable.objectNames
	}
	
	public func set(name nm: String, value val: JSValue) {
		self.propertyTable.set(nm, val)
	}

	public func set(name nm: String, boolValue bval: Bool){
		let val = JSValue(bool: bval, in: context)
		self.propertyTable.set(nm, val!)
	}

	public func set(name nm: String, int32Value ival: Int32){
		let val = JSValue(int32: ival, in: context)
		self.propertyTable.set(nm, val!)
	}

	public func set(name nm: String, stringValue sval: String){
		let val = JSValue(object: sval, in: context)
		self.propertyTable.set(nm, val!)
	}

	public func set(name nm: String, arrayValue aval: Array<Any>){
		let val = JSValue(object: aval, in: context)
		self.propertyTable.set(nm, val!)
	}

	public func get(name nm: String) -> JSValue? {
		return self.propertyTable.check(nm)
	}

	public func getBool(name nm: String) -> Bool? {
		if let val = propertyTable.check(nm) {
			if val.isBoolean {
				return val.toBool()
			}
		}
		return nil
	}

	public func getInt32(name nm: String) -> Int32? {
		if let val = propertyTable.check(nm) {
			if val.isNumber {
				return val.toInt32()
			}
		}
		return nil
	}

	public func getString(name nm: String) -> String? {
		if let val = propertyTable.check(nm) {
			if val.isString {
				return val.toString()
			}
		}
		return nil
	}

	public func getArray(name nm: String) -> Array<Any>? {
		if let val = propertyTable.check(nm) {
			if val.isObject {
				if let arr = val.toObject() as? Array<Any> {
					return arr
				}
			}
		}
		return nil
	}

	public func object(name nm: String) -> KMObjectValue? {
		return objectTable.object(name: nm)
	}

	public func set(name nm: String, object obj: KMObjectValue) {
		objectTable.set(name: nm, object: obj)
	}
}
