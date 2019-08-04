/**
 * @file	KLNativeStruct.swift
 * @brief	Extend CNNativeStruct class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import CoconutData
import JavaScriptCore
import Foundation

extension CNNativeStruct
{
	public func JSClassDefinition() -> String {
		var stmts: Array<String> = []
		stmts.append("class \(self.structName) {\n")

		/* Define constructor */
		let members = self.members

		stmts.append("  constructor(object) {\n")
		for ident in members.keys.sorted() {
			let stmt = "    this._\(ident) = object.\(ident) ;\n"
			stmts.append(stmt)
		}
		stmts.append("  }\n")

		/* Define getter */
		for ident in members.keys.sorted() {
			let getter = "  get \(ident)() { return this._\(ident) ; }\n"
			let setter = "  set \(ident)(newval) { this._\(ident) = newval ; }\n"
			stmts.append(getter)
			stmts.append(setter)
		}

		/* Defint to object method */
		stmts.append("  toParameter(){\n")
		stmts.append("    let object = {\n")
		for ident in members.keys.sorted() {
			stmts.append("    \(ident): this._\(ident),\n")
		}
		stmts.append("    } ;\n")
		stmts.append("    return object ;\n")
		stmts.append("  }\n")

		/* End of the class */
		stmts.append("}\n")

		return stmts.joined(separator: "")
	}
}


