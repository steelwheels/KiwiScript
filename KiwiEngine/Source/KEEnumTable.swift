/**
 * @file	KEEnumTable.swift
 * @brief	Define KEEnumTable class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import JavaScriptCore
import Foundation

public protocol KEEnumProtocol: JSExport
{
	func get(_ name: String) -> JSValue
}

@objc public class KEEnumObject: NSObject, KEEnumProtocol
{
	private var mContext:	  KEContext
	private var mEnumMembers: Dictionary<String, Int32>		// member name, value

	public init(context ctxt: KEContext){
		mContext = ctxt
		mEnumMembers = [:]
	}

	public func allMembers() -> Array<String> {
		return Array(mEnumMembers.keys)
	}

	public func get(_ name: String) -> JSValue {
		if let val = mEnumMembers[name] {
			return JSValue(int32: val, in: mContext)
		} else {
			return JSValue(nullIn: mContext)
		}
	}

	public func set(name nm: String, value val: Int32){
		mEnumMembers[nm] = val
	}

	public func value(forMember memb: String) -> Int32? {
		return mEnumMembers[memb]
	}
}

public class KEEnumTable
{
	private var mEnumTable: Dictionary<String, KEEnumObject>	// enum name, enum object

	public init(){
		mEnumTable = [:]
	}

	public func set(name nm: String, object obj: KEEnumObject){
		mEnumTable[nm] = obj
	}

	public func value(forClass name:String, forMember memb: String) -> Int32? {
		if let obj = mEnumTable[name] {
			return obj.value(forMember: memb)
		}
		return nil
	}
}
