/**
 * @file	KMObjectParser.swift
 * @brief	Define KMObjectParser class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KMObjectParser
{
	public enum Result {
		case ok(KMObject)
		case error(NSError)
	}

	public func parse(source src: String) -> Result {
		/* Remove comments in the string */
		let lines = removeComments(lines: src.components(separatedBy: "\n"))
		for line in lines {
			NSLog("\(line)")
		}
		return .ok(.bool(true))
	}

	private func removeComments(lines lns: Array<String>) -> Array<String> {
		var result: Array<String> = []
		for line in lns {
			let parts = line.components(separatedBy: "//")
			result.append(parts[0])
		}
		return result
	}
}

