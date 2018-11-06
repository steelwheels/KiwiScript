/**
 * @file	KMEnumTable.swift
 * @brief	Define KMEnumTable class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiEngine
import KiwiLibrary
import CoconutData
import JavaScriptCore
import Foundation

public class KMEnumTable: KMDefaultObject
{
	public func set(enumTypeName name: String, enumType etype: KMEnumType){
		self.propertyTable.set(name, JSValue(object: etype, in: context))
	}

	public func get(enumTypeName name: String) -> KMEnumType? {
		if let val = super.get(name: name) {
			if val.isObject {
				if let etype = val.toObject() as? KMEnumType {
					return etype
				}
			}
		}
		return nil
	}
}

public class KMEnumType: KMDefaultObject
{
	public func set(memberName name: String, value v: Int32) {
		if let val = JSValue(int32: v, in: context) {
			self.propertyTable.set(name, val)
		} else {
			NSLog("Failed to allocate value at #(function)")
		}
	}

	public func get(memberName name: String) -> Int32? {
		if let val = super.get(name: name) {
			if val.isNumber {
				return val.toInt32()
			}
		}
		return nil
	}
}
