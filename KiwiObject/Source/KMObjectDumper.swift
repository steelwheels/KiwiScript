/**
 * @file	KMObjectDumper.swift
 * @brief	Define KMObjectDumper class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KMObjectDumper
{
	public init() {

	}

	public func dump(object obj: KMObject) -> CNTextSection {
		let section = CNTextSection()
		section.header = "{"
		section.footer = "}"

		let props = obj.properties
		for prop in props {
			let text = dump(property: prop)
			section.add(text: text)
		}
		return section
	}

	private func dump(property prop: KMProperty) -> CNText {
		let result: CNText
		let name = prop.name
		switch prop.value {
		case .bool(let value):
			result = CNTextLine(string: "\(name): bool \(value)")
		case .int(let value):
			result = CNTextLine(string: "\(name): int \(value)")
		case .float(let value):
			result = CNTextLine(string: "\(name): float \(value)")
		case .string(let value):
			result = CNTextLine(string: "\(name): string \"\(value)\"")
		case .object(let typename, let value):
			let valtxt = dump(object: value)
			valtxt.header = name + ": " + typename + " " + valtxt.header
			result = valtxt
		}
		return result
	}
}
