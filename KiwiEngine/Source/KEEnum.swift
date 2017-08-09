/**
 * @file	KEEnum.swift
 * @brief	Implementation of enum for JavaScript
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation
import JavaScriptCore

public class KEEnum
{
	public  var typeName:	String
	private var mMembers:	Dictionary<String, Int>

	public init(typeName name: String){
		typeName = name
		mMembers = [:]
	}

	public func setValue(value val: Int, forKey key: String){
		mMembers[key] = val
	}

	public func value(forKey key: String) -> Int? {
		return mMembers[key]
	}

	public func allKeys() -> Array<String> {
		return Array(mMembers.keys)
	}

	public func makeScript() -> String? {
		if mMembers.count > 0 {
			let keys = allKeys()
			var script = "var \(typeName) = {\n"
			for key in keys {
				if let value = mMembers[key] {
					script = script + "\t\(key) : \(value),\n"
				} else {
					fatalError("Can not happen")
				}
			}
			script = script + "};\n"
			return script
		}
		return nil
	}
}

public class KEEnumTable
{
	private var mTypeNameDictionary:	Dictionary<String, KEEnum>
	private var mMemberDictionary:		Dictionary<String, Array<KEEnum>>

	public init(){
		mTypeNameDictionary = [:]
		mMemberDictionary   = [:]
	}

	public func addEnum(enumType etype: KEEnum){
		mTypeNameDictionary[etype.typeName] = etype

		let keys = etype.allKeys()
		for key in keys {
			if var etypes = mMemberDictionary[key] {
				etypes.append(etype)
			} else {
				mMemberDictionary[key] = [etype]
			}
		}
	}

	public func search(byTypeName name: String) -> KEEnum? {
		return mTypeNameDictionary[name]
	}

	public func search(byMemberName name: String) -> Array<KEEnum> {
		if let etypes = mMemberDictionary[name] {
			return etypes
		} else {
			return []
		}
	}

}

