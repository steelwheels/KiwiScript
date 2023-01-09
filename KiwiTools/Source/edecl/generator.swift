/**
 * @file	generator..swift
 * @brief	Define functions to generate enum declaration
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import Foundation

public func generateEnumDeclaration(enumName name: String, enumType etype: CNEnumType, console cons: CNConsole, config conf: Config)
{
	let decl = CNTextSection()
	decl.add(text: CNTextLine(string: "/* Enum declaration: \(name) */"))
	decl.add(text: etype.toDeclaration())

	let outurl = URL(fileURLWithPath: "enum-\(name).d.ts")

	let str = decl.toStrings().joined(separator: "\n")
	if !outurl.storeContents(contents: str + "\n") {
		cons.print(string: "[Error] Failed to make output file: \(outurl.path)\n")
	}
}

public func generateInterfaceDeclaration(interfaceName name: String, interfaceType iftype: CNInterfaceType, console cons: CNConsole, config conf: Config)
{
	let decl = CNTextSection()
	decl.add(text: CNTextLine(string: "/* Interface declaration: \(name) */"))

	decl.add(text: declarationOf(interfaceType: iftype))

	let outurl = URL(fileURLWithPath: "intf-\(name).d.ts")

	let str = decl.toStrings().joined(separator: "\n")
	if !outurl.storeContents(contents: str + "\n") {
		cons.print(string: "[Error] Failed to make output file: \(outurl.path)\n")
	}
}

private func declarationOf(interfaceType iftype: CNInterfaceType) -> CNText
{
	let result = CNTextSection()

	let extends: String
	if let bs = iftype.base {
		extends = "extends \(bs.name)"
	} else {
		extends = ""
	}
	result.add(text: CNTextLine(string: "interface \(iftype.name) \(extends){"))

	for name in iftype.types.keys.sorted() {
		if let type = iftype.types[name] {
			let typestr = convertToTypeDeclarationWithRecv(valueType: type, isInside: false)
			let line: String = "\t\(name): \(typestr) ;"
			result.add(text: CNTextLine(string: line))
		}
	}

	result.add(text: CNTextLine(string: "}"))

	return result
}

private func convertToTypeDeclarationWithRecv(valueType vtype: CNValueType, isInside isin: Bool) -> String {
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

