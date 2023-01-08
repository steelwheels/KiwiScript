/**
 * @file	KLValuePointer.swift
 * @brief	Extend CNValuePointer class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation

public extension CNInterfaceValue
{
	private static let InterfaceName	= "_ifName"

	static func interfaceName(scriptValue val: JSValue) -> String? {
		if let dict = val.toDictionary() as? Dictionary<String, AnyObject> {
			if let ifname = dict[InterfaceName] as? String {
				return ifname
			}
		}
		return nil
	}

	static func isInterface(scriptValue val: JSValue) -> Bool {
		if let _ = interfaceName(scriptValue: val) {
			return true
		} else {
			return false
		}
	}

	static func fromJSValue(scriptValue val: JSValue) -> Result<CNInterfaceValue, NSError> {
		if let ifname = interfaceName(scriptValue: val) {
			let result: Result<CNInterfaceValue, NSError>
			if let iftype = CNInterfaceTable.currentInterfaceTable().search(byTypeName: ifname) {
				if let dict = val.toDictionary() as? Dictionary<String, AnyObject> {
					result = fromJSValue(interfaceType: iftype, values: dict)
				} else {
					result = .failure(NSError.parseError(message: "No dictionary: \(ifname)"))
				}
			} else {
				result = .failure(NSError.parseError(message: "Unknown interface: \(ifname)"))
			}
			return result
		} else {
			return .failure(NSError.parseError(message: "No \(InterfaceName) property"))
		}
	}

	static func fromJSValue(interfaceType iftype: CNInterfaceType, values vals: Dictionary<String, AnyObject>) -> Result<CNInterfaceValue, NSError> {
		var values: Dictionary<String, CNValue> = [:]
		let converter = CNAnyObjecToValue()
		for (key, elm) in vals {
			if key != InterfaceName {
				values[key] = converter.convert(anyObject: elm)
			}
		}
		let ifval = CNInterfaceValue(types: iftype, values: values)
		if ifval.validate() {
			return .success(ifval)
		} else {
			let val: CNValue = .interfaceValue(ifval)
			return .failure(NSError.parseError(message: "Failed to validate interface value:" + "\(val.description)"))
		}
	}

	func toJSValue(context ctxt: KEContext) -> JSValue {
		var src = self.values
		src[CNInterfaceValue.InterfaceName] = .stringValue(self.toType().name)

		let converter = CNValueToAnyObject()
		let obj       = converter.convert(dictionaryValue: src)
		return JSValue(object: obj, in: ctxt)
	}
}
