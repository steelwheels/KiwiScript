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
		for (ename, etype) in self.allTypes {
			/* Member definition */
			let sect = CNTextSection()
			sect.header = "declare enum \(ename) {"
			sect.footer = "}"

			let list = CNTextList()
			list.separator = ","
			for memb in etype.members {
				let line = CNTextLine(string: "\(memb.name) = \(memb.value)")
				list.add(text: line)
			}
			sect.add(text: list)

			/* Static methods definition */
			let decls = CNTextSection()
			decls.header = "declare namespace \(ename) {"
			decls.footer = "}"

			let dscfunc = CNTextLine(string: "function description(param: \(ename)): string ;")
			decls.add(text: dscfunc)

			result.add(text: sect)
			result.add(text: decls)
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
		for (ename, etype) in self.allTypes {
			/* Member definition */
			let defsect = CNTextSection()
			defsect.header = "const \(ename) = {"
			defsect.footer = "} ;"

			let list = CNTextList()
			list.separator = ","
			for memb in etype.members {
				let line = CNTextLine(string: "\(memb.name): \(memb.value)")
				list.add(text: line)
			}

			/* static method definition */
			if etype.search(byName: "description") == nil {
				let descfunc = CNTextSection()
				descfunc.header = "description: function(val) {"
				descfunc.footer = "}"

				let switchfunc = CNTextSection()
				switchfunc.header = "let result = \"?\" ; switch(val){"
				switchfunc.footer = "} ; return result ;"
				for memb in etype.members {
					let stmt = "   case \(memb.value): result=\"\(memb.name)\" ; break ;"
					switchfunc.add(text: CNTextLine(string: stmt))
				}
				descfunc.add(text: switchfunc)
				list.add(text: descfunc)
			}
			defsect.add(text: list)
			result.add(text: defsect)
		}

		
		return result
	}

}
