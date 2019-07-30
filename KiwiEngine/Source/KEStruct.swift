/**
 * @file	KEStruct.swift
 * @brief	Define KEStruct class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import CoconutData
import JavaScriptCore
import Foundation

public class KEStruct
{
	private var mStructName:	String
	private var mMembers:		Dictionary<String, CNNativeValue>

	public init(name nm: String){
		mStructName = nm
		mMembers    = [:]
	}

	public func member(name nm: String) -> CNNativeValue? {
		return mMembers[nm]
	}

	public func setMember(name nm: String, value val: CNNativeValue){
		mMembers[nm] = val
	}

	public func JSClassDefinition() -> String {
		var stmts: Array<String> = []
		stmts.append("class \(mStructName) {\n")

		/* Define constructor */
		stmts.append("  constructor(object) {\n")
		for ident in mMembers.keys.sorted() {
			let stmt = "    this._\(ident) = object.\(ident) ;\n"
			stmts.append(stmt)
		}
		stmts.append("  }\n")

		/* Define getter */
		for ident in mMembers.keys.sorted() {
			let getter = "  get \(ident)() { return this._\(ident) ; }\n"
			let setter = "  set \(ident)(newval) { this._\(ident) = newval ; }\n"
			stmts.append(getter)
			stmts.append(setter)
		}

		/* Defint to object method */
		stmts.append("  toObject(){\n")
		stmts.append("    let object = {\n")
		for ident in mMembers.keys.sorted() {
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

