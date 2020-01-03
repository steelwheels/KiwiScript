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
	let translator = KHShellTranslator(readline: nil)

	let script0: Array<String> = []
	let result0    = testTrans(translator: translator, testNo: 0, source: script0, console: cons)

	let script1: Array<String> = [
		"let a = 1.0;",
		"> echo \"Hello, world !!\\n\"",
		"console.log(a)"
	]
	let result1    = testTrans(translator: translator, testNo: 1, source: script1, console: cons)

	let script2: Array<String> = [
		"> a | b | c",
		"> |d"
	]
	let result2    = testTrans(translator: translator, testNo: 2, source: script2, console: cons)

	let script3: Array<String> = [
		"> cat A | wc -l ; cat B |  wc -l"
	]
	let result3    = testTrans(translator: translator, testNo: 3, source: script3, console: cons)

	let script4: Array<String> = [
		"> cat A-> exitcode0 "
	]
	let result4    = testTrans(translator: translator, testNo: 4, source: script4, console: cons)

	let script5: Array<String> = [
		"> cat < @pipein > @pipeout "
	]
	let result5    = testTrans(translator: translator, testNo: 5, source: script5, console: cons)

	let script6: Array<String> = [
		"> cat < @pipein | wc -l > @pipeout "
	]
	let result6    = testTrans(translator: translator, testNo: 6, source: script6, console: cons)

	let script7: Array<String> = [
		"> history "
	]
	let result7    = testTrans(translator: translator, testNo: 7, source: script7, console: cons)

	return result0 && result1 && result2 && result3 && result4 && result5 && result6 && result7
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
