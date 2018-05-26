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
	var instanceName: 		String { get }
	var propertyTable: 		KEPropertyTable { get }
	var objectTable:		Dictionary<String, KEObject> { get set }
}

public class KEDefaultObject: KEObject
{
	private var mContext:		KEContext
	private var mInstanceName:	String
	private var mPropertyTable:	KEPropertyTable
	private var mObjectTable:	Dictionary<String, KEObject>

	public var instanceName: 	String { get { return mInstanceName }}
	public var propertyTable: 	KEPropertyTable { get { return mPropertyTable }}
	public var objectTable:		Dictionary<String, KEObject> {
						get { return mObjectTable }
						set(table){ mObjectTable = table }
					}
	public var context: 		KEContext { get { return mContext } }

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

	public func get(name nm: String) -> JSValue {
		return self.get(name: nm)
	}

	public func check(name nm: String) -> JSValue? {
		return self.get(name: nm)
	}

	public func object(name nm: String) -> KEObject? {
		return self.objectTable[nm]
	}
}
