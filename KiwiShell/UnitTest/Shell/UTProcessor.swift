/**
 * @file	UTProcessor.swift
 * @brief	Test function for shell processor
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import KiwiShell
import KiwiEngine
import KiwiLibrary
import CoconutData
import CoconutShell
import JavaScriptCore
import Foundation

public func UTPreProcessor(console cons: CNConsole) -> Bool
{
	let processor = KHShellProcessor()
	convert(processor: processor, statements: ["hello, world"], console: cons)
	convert(processor: processor, statements: ["> ls -l"], console: cons)
	return true
}

private func convert(processor proc: KHShellProcessor, statements stmts: Array<String>, console cons: CNConsole)
{
	cons.print(string: "<Source>\n")
	for stmt in stmts {
		cons.print(string: " \"\(stmt)\"\n")
	}
	cons.print(string: "<Convert>\n")
	switch proc.convert(statements: stmts) {
	case .finished(let results):
		for res in results {
			cons.print(string: " \"\(res)\"\n")
		}
	case .error(let err):
		let errmsg = err.descriotion()
		cons.print(string: "[Error] \(errmsg)\n")
	}
}
