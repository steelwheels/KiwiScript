/**
 * @file	UTTranslator.swift
 * @brief	Test function for KHShellTranslator class
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

public func UTTranslator(console cons: CNConsole) -> Bool
{
	let translator = KHShellTranslator()

	let script0: Array<String> = []
	let result0    = testTrans(translator: translator, testNo: 0, source: script0, console: cons)

	let script1: Array<String> = [
		"let a = 1.0;",
		"> echo \"Hello, world !!\\n\"",
		"console.log(a)"
	]
	let result1    = testTrans(translator: translator, testNo: 1, source: script1, console: cons)

	return result0 && result1
}

private func testTrans(translator trans: KHShellTranslator, testNo testno: Int, source srcs: Array<String>, console cons: CNConsole) -> Bool
{
	cons.print(string: "/* Source script \(testno) */\n")
	for src in srcs {
		cons.print(string: src + "\n")
	}

	cons.print(string: "/* Translated script \(testno) */\n")
	let result: Bool
	switch trans.translate(lines: srcs) {
	case .ok(let lines):
		for line in lines {
			cons.print(string: line + "\n")
		}
		result = true
	case .error(let err):
		let errobj = err as NSError
		cons.error(string: "[Error] " + errobj.toString() + "\n")
		result = false
	}
	return result
}
