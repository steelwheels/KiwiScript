/**
 * @file	KEEnumTable.swift
 * @brief	Define KEEnumTable class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import CoconutData

public extension CNEnumTable
{
	static func loadFromResource(resource res: KEResource) -> Result<CNEnumTable?, NSError> {
		let table = CNEnumTable()
		if let count = res.countOfDefinitions() {
			let parser = CNValueParser()
			for i in 0..<count {
				if let script = res.loadDefinition(index: i) {
					switch parser.parse(source: script) {
					case .success(let val):
						switch CNEnumTable.fromValue(value: val) {
						case .success(let tblp):
							if let tbl = tblp {
								table.merge(enumTable: tbl)
							}
						case .failure(let err):
							return .failure(err)
						}
					case .failure(let err):
						return .failure(err)
					}
				}
			}
		}
		return .success(table.count > 0 ? table : nil)
	}

	/*
	 * declare enum Weekday {
	 *   sun = 0,
	 *   mon = 1,
	 *   tue = 2
	 * }
	 * declare namespace Weekday {
	 *    function description(day: Weekday): string;
	 * }
	 */
	func toDeclaration() -> CNTextSection {
		let result: CNTextSection = CNTextSection()
		guard self.count > 0 else {
			return result
		}
		let enames = self.allTypes.keys.sorted()
		for ename in enames {
			if let etype = self.search(byTypeName: ename) {
				/* Member definition */
				let sect = CNTextSection()
				sect.header = "declare enum \(ename) {"
				sect.footer = "}"

				let list = CNTextList()
				list.separator = ","
				for name in etype.names {
					if let value = etype.value(forMember: name) {
						let line = CNTextLine(string: "\(name) = \(value)")
						list.add(text: line)
					} else {
						CNLog(logLevel: .error, message: "Can not happen", atFunction: #function, inFile: #file)
					}
				}
				sect.add(text: list)

				/* Static methods definition */
				let decls = CNTextSection()
				decls.header = "declare namespace \(ename) {"
				decls.footer = "}"

				let dscfunc = CNTextLine(string: "function description(param: \(ename)): string ;")
				decls.add(text: dscfunc)

				let keysvar = CNTextLine(string: "const keys: string[] ;")
				decls.add(text: keysvar)

				result.add(text: sect)
				result.add(text: decls)
			} else {
				CNLog(logLevel: .error, message: "Can not happen", atFunction: #function, inFile: #file)
			}
		}
		return result
	}

	/*
	 * // member definition
	 * const Position = {
	 *  Top: 0,
	 *  Right: 1,
	 *  Bottom: 2,
	 *  Left: 3,
	 * } ;
	 */
	func toScript() -> CNTextSection {
		let result: CNTextSection = CNTextSection()
		guard self.count > 0 else {
			return result
		}
		let enames = self.allTypes.keys.sorted()
		for ename in enames {
			if let etype = self.search(byTypeName: ename) {
				/* Member definition */
				let defsect = CNTextSection()
				defsect.header = "const \(ename) = {"
				defsect.footer = "} ;"
				result.add(text: defsect)

				let list = CNTextList()
				list.separator = ","
				for name in etype.names {
					if let value = etype.value(forMember: name) {
						let line = CNTextLine(string: "\(name): \(value)")
						list.add(text: line)
					} else {
						CNLog(logLevel: .error, message: "Can not happen", atFunction: #function, inFile: #file)
					}
				}
				defsect.add(text: list)

				/* static method definition */
				/* "description" function */
				if etype.value(forMember: "description") == nil {
					let descfunc = CNTextSection()
					descfunc.header = "description: function(val) {"
					descfunc.footer = "}"

					let switchfunc = CNTextSection()
					switchfunc.header = "let result = \"?\" ; switch(val){"
					switchfunc.footer = "} ; return result ;"
					for name in etype.names {
						if let value = etype.value(forMember: name) {
							let stmt = "   case \(value): result=\"\(name)\" ; break ;"
							switchfunc.add(text: CNTextLine(string: stmt))
						} else {
							CNLog(logLevel: .error, message: "Can not happen", atFunction: #function, inFile: #file)
						}
					}
					descfunc.add(text: switchfunc)
					list.add(text: descfunc)
				}

				/* "keys" variable */
				if etype.value(forMember: "keys") == nil {
					let keys     = etype.names.map{ "\"" + $0 + "\"" }
					let keystr   = keys.joined(separator: ", ")
					let keysline = CNTextLine(string: "keys: [\(keystr)]")
					list.add(text: keysline)
				}
				//let dump = defsect.toStrings().joined(separator: "\n")
				//NSLog("enum = " + dump)
			} else {
				CNLog(logLevel: .error, message: "Can not happen", atFunction: #function, inFile: #file)
			}
		}
		return result
	}

}
