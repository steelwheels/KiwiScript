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

