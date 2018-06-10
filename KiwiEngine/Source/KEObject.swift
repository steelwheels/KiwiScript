/**
 * @file	KEObject.swift
 * @brief	Define KEObject protocol
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import JavaScriptCore
import Foundation

public enum KEObjectValue
{
	case Object(KEObject)
	case Function(KEFunction)

	func toObject() -> KEObject? {
		switch self {
		case .Object(let obj):		return obj
		case .Function(_):		return nil
		}
	}

	func toFunction() -> KEFunction? {
		switch self {
		case .Object(_):		return nil
		case .Function(let fnc):	return fnc
		}
	}
}

public protocol KEObject
{
	var context:			KEContext { get }
	var modelName:			String { get }
	var instanceName: 		String { get }
	var propertyTable: 		KEPropertyTable { get }
	var objectTable:		KEObjectTable { get }

	func set(name nm: String, object obj: KEObjectValue)
}

public class KEObjectTable
{
	private var mObjectTable:	Dictionary<String, KEObjectValue>

	public init(){
		mObjectTable = [:]
	}

	public var objectNames: Array<String> {
		get { return Array(mObjectTable.keys) }
	}

	public func set(name nm: String, object obj: KEObjectValue){
		mObjectTable[nm] = obj
	}

	public func object(name nm: String) -> KEObjectValue? {
		return mObjectTable[nm]
	}
}

open class KEDefaultObject: KEObject
{
	private var mContext:		KEContext
	private var mInstanceName:	String
	private var mPropertyTable:	KEPropertyTable
	private var mObjectTable:	KEObjectTable

	public var context: 		KEContext { get { return mContext } }
	public var modelName:		String { get { return "Object" }}
	public var instanceName: 	String { get { return mInstanceName }}
	public var propertyTable: 	KEPropertyTable { get { return mPropertyTable }}
	public var objectTable:		KEObjectTable { get { return mObjectTable }}

	public init(instanceName iname: String, context ctxt: KEContext){
		mContext	= ctxt
		mInstanceName	= iname
		mPropertyTable	= KEPropertyTable(context: ctxt)
		mObjectTable	= KEObjectTable()
	}

	public func set(name nm: String, object obj: KEObjectValue){
		mObjectTable.set(name: nm, object: obj)
		switch obj {
		case .Object(let obj):
			if let prop = JSValue(object: obj.propertyTable, in: context) {
				propertyTable.set(nm, prop)
			} else {
				NSLog("Failed to allocate")
			}
		case .Function(let obj):
			propertyTable.set(nm, obj.functionObject)
			break
		}
	}
}

extension KEObject
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

	public func object(name nm: String) -> KEObjectValue? {
		return objectTable.object(name: nm)
	}

	public func set(name nm: String, object obj: KEObjectValue) {
		objectTable.set(name: nm, object: obj)
	}
}
