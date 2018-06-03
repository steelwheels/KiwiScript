/**
 * @file	KEObject.swift
 * @brief	Define KEObject protocol
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import JavaScriptCore
import Foundation

public protocol KEObject
{
	var context:			KEContext { get }
	var instanceName: 		String { get }
	var propertyTable: 		KEPropertyTable { get }
	var objectTable:		Dictionary<String, KEObject> { get set }

	func set(name nm: String, object obj: KEObject)
}

open class KEDefaultObject: KEObject
{
	private var mContext:		KEContext
	private var mInstanceName:	String
	private var mPropertyTable:	KEPropertyTable
	private var mObjectTable:	Dictionary<String, KEObject>

	public var context: 		KEContext { get { return mContext } }
	public var instanceName: 	String { get { return mInstanceName }}
	public var propertyTable: 	KEPropertyTable { get { return mPropertyTable }}
	public var objectTable:		Dictionary<String, KEObject> {
						get { return mObjectTable }
						set(table){ mObjectTable = table }
					}

	public init(instanceName iname: String, context ctxt: KEContext){
		mContext	= ctxt
		mInstanceName	= iname
		mPropertyTable	= KEPropertyTable(context: ctxt)
		mObjectTable	= [:]
	}

	public func set(name nm: String, object obj: KEObject){
		self.objectTable[nm] = obj
		if let prop = JSValue(object: obj.propertyTable, in: context) {
			propertyTable.set(nm, prop)
		} else {
			NSLog("Failed to allocate")
		}
	}
}

extension KEObject
{
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

	public func object(name nm: String) -> KEObject? {
		return self.objectTable[nm]
	}
}
