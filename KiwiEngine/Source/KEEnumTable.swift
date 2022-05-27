/**
 * @file	KEEnumTable.swift
 * @brief	Define KEEnumTable class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import CoconutData

extension CNEnumTable
{
	public static func loadFromResource(resource res: KEResource) -> Result<CNEnumTable?, NSError> {
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
}
