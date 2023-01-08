/**
 * @file	KLValueType.swift
 * @brief	Extend CNValueTyoe class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

public extension CNValueType
{
	func toTypeDeclaration() -> String {
		return CNValueType.convertToTypeDeclaration(valueType: self)
	}

	static func convertToTypeDeclaration(valueType vtype: CNValueType) -> String {
		return convertToTypeDeclarationWithRecv(valueType: vtype, isInside: false)
	}

	static func convertToTypeDeclarationWithRecv(valueType vtype: CNValueType, isInside isin: Bool) -> String {
		let result: String
		switch vtype {
		case .anyType:
			result = "any"
		case .voidType:
			result = "void"
		case .boolType:
			result = "boolean"
		case .numberType:
			result = "number"
		case .stringType:
			result = "string"
		case .enumType(let etype):
			result = etype.typeName
		case .dictionaryType(let elmtype):
			result = "{[key: string]: " + convertToTypeDeclarationWithRecv(valueType: elmtype, isInside: true) + "}"
		case .arrayType(let elmtype):
			result = convertToTypeDeclarationWithRecv(valueType: elmtype, isInside: true) + "[]"
		case .setType(let elmtype):
			result = convertToTypeDeclarationWithRecv(valueType: elmtype, isInside: true) + "[]"
		case .objectType(let clsname):
			if let name = clsname {
				result = name
			} else {
				result = "any /* anyobject */"
			}
		case .interfaceType(let iftype):
			result = iftype.name
		case .functionType(let rettype, let paramtypes):
			var str: String = "("
			for i in 0..<paramtypes.count {
				if i > 0 { str += ", " }
				str += "p\(i): " + convertToTypeDeclarationWithRecv(valueType: paramtypes[i], isInside: true)
			}
			let arrow = isin ? " =>" : ":"
			str += ")\(arrow) " + convertToTypeDeclarationWithRecv(valueType: rettype, isInside: true)
			result = str
		@unknown default:
			result = "any /* unknown */"
		}
		return result
	}
}
