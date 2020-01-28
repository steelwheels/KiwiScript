/**
 * @file	UTTParser.swift
 * @brief	Test function for KHShellParser class
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

public func UTParser(console cons: CNConsole) -> Bool
{
	let parser   = KHShellParser()
	let readline = CNReadline()

	let stmt0 = ["let a = 10 ;"]
	let res0  = testParser(parser: parser, testNo: 0, source: stmt0, readline: readline, console: cons)

	let stmt1: Array<String> = [
		"let a = 1.0;",
		"> echo \"Hello, world !!\\n\"",
		"console.log(a)"
	]
	let res1 = testParser(parser: parser, testNo: 1, source: stmt1, readline: readline, console: cons)

	let stmt2: Array<String> = [
		"> a | b | c",
		"> |d"
	]
	let res2 = testParser(parser: parser, testNo: 2, source: stmt2, readline: readline, console: cons)

	let stmt3: Array<String> = [
		"> cat A ; cat B"
	]
	let res3 = testParser(parser: parser, testNo: 3, source: stmt3, readline: readline, console: cons)

	let stmt4: Array<String> = [
		"> cat A | wc -l ; cat B |  wc -l"
	]
	let res4 = testParser(parser: parser, testNo: 4, source: stmt4, readline: readline, console: cons)

	let stmt5: Array<String> = [
		"> cat A -> exitcode0 "
	]
	let res5 = testParser(parser: parser, testNo: 5, source: stmt5, readline: readline, console: cons)

	let stmt6: Array<String> = [
		"> cat < @pipein > @pipeout "
	]
	let res6 = testParser(parser: parser, testNo: 6, source: stmt6, readline: readline, console: cons)

	let stmt7: Array<String> = [
		"> cat < filein | wc -l > fileout "
	]
	let res7 = testParser(parser: parser, testNo: 7, source: stmt7, readline: readline, console: cons)

	let stmt8: Array<String> = [
		"> cat < @pipein | wc -l > @pipeout "
	]
	let res8 = testParser(parser: parser, testNo: 8, source: stmt8, readline: readline, console: cons)

	let stmt9: Array<String> = [
                "> run test.js > a"
        ]
	let res9 = testParser(parser: parser, testNo: 9, source: stmt9, readline: readline, console: cons)

	let stmt10: Array<String> = [
                "> history "
        ]
	let res10 = testParser(parser: parser, testNo: 10, source: stmt10, readline: readline, console: cons)

	let stmt11: Array<String> = [
		"> ls | wc -l ;",
                "> history ;",
		"> !1 ;"
        ]
	let res11 = testParser(parser: parser, testNo: 11, source: stmt11, readline: readline, console: cons)

	return res0 && res1 && res2 && res3 && res4 && res5 && res6 && res7 && res8 && res9 && res10 && res11
}

private func testParser(parser psr: KHShellParser, testNo testno: Int, source srcs: Array<String>, readline rdln: CNReadline, console cons: CNConsole) -> Bool
{
	cons.print(string: "-- Unit test: \(testno)\n")
	cons.print(string: " - Source\n")
	for src in srcs {
		cons.print(string: "    \(src)\n")
	}

	var result: Bool
	switch psr.parse(lines: srcs) {
	case .ok(let stmts):
		let newstmts = KHCompileShellStatement(statements: stmts, readline: rdln)
		#if false
			cons.print(string: " - Compile\n")
			for stmt in newstmts {
				stmt.dump(indent: 1, to: cons)
			}
		#endif
		let script   = KHGenerateScript(from: newstmts)
		#if true
			cons.print(string: " - Script\n")
			for line in script {
				cons.print(string: line + "\n")
			}
		#endif
		result = true
	case .error(let err):
		cons.print(string: "[Error] \(err.localizedDescription)\n")
		result = false
	}
	return result
}


