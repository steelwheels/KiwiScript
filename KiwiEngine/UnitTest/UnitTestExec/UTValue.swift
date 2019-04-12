/**
 * @file		UTValue.swift
 * @brief	Unit test for KiwiEngine framework
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
import Foundation
import JavaScriptCore
import KiwiEngine

private class UTCompiler: KECompiler
{
	public func main(context ctxt: KEContext, console cons: CNConsole, config conf: KEConfig) -> Bool {

		/* Bool */
		cons.print(string: "/* Bool: true */\n")
		let b0 = self.compile(context: ctxt, statement: "b0 = true ;\n", console: cons, config: conf)
		printValue(value: b0, context: ctxt)

		/* Int */
		console.print(string: "/* Number: 123 */\n")
		let i0 = self.compile(context: ctxt, statement: "i0 = 123 ;\n", console: cons, config: conf)
		printValue(value: i0, context: ctxt)

		/* Float */
		console.print(string: "/* Number: 123.4 */\n")
		let f0 = self.compile(context: ctxt, statement: "f0 = 123.4 ;\n", console: cons, config: conf)
		printValue(value: f0, context: ctxt)

		/* String */
		console.print(string: "/* String: \"hello\" */\n")
		let s0 = self.compile(context: ctxt, statement: "s0 = \"hello\" ;\n", console: cons, config: conf)
		printValue(value: s0, context: ctxt)

		/* Point */
		let stmtp = "p0 = {x:10.0, y:11.1} ;\n"
		let p0 = self.compile(context: ctxt, statement: stmtp, console: cons, config: conf)
		printValue(value: p0, context: ctxt)

		/* Array */
		console.print(string: "/* Array: [0, 1, 2, 3, 3.1] */\n")
		let a0 = self.compile(context: ctxt, statement: "a0 = [0, 1, 2, 3, 3.1] ;\n", console: cons, config: conf)
		printValue(value: a0, context: ctxt)

		/* Dictionary */
		console.print(string: "/* Dictionary: {a:0, b:1, c:2, d:3, e:3.1} */\n")
		let d0 = self.compile(context: ctxt, statement: "d0 = {a:0, b:1, c:2, d:3, e:3.1} ;\n", console: cons, config: conf)
		printValue(value: d0, context: ctxt)

		/* Dictionary */
		console.print(string: "/* Dictionary: {origin: {x:10.0, y:11.0}, size: {width:20.0, height: 21.0}} */\n")
		let d1 = self.compile(context: ctxt, statement: "d1 = {origin: {x:10.0, y:11.0}, size: {width:20.0, height: 21.0}};\n", console: cons, config: conf)
		printValue(value: d1, context: ctxt)

		/* Dictionary */
		let stmt =
			"d2 = {\n" +
			"  imageFile:      \"Images/blue-symbol.png\",\n" +
			"  scale:          0.5,\n" +
			"  alpha:          1.0,\n" +
			"  position:       {x:10.0, y:10.0},\n" +
			"  rotation:       0.5,\n" +
			"  duration:       1.0\n" +
			"}"
		console.print(string: "/* Dictionary: \(stmt) */\n")
		let d2 = self.compile(context: ctxt, statement: stmt, console: cons, config: conf)
		printValue(value: d2, context: ctxt)

		/* Class */
		let c0stmt = "class A { \n" +
			     " constructor(){ this.x = 10 ; }\n" +
			     " funcA(){ return 1 ; }\n" +
			     "} ; \n" +
			     "aobject = new A() ;"
		console.print(string: "/* \(c0stmt) */\n")
		let c0 = self.compile(context: ctxt, statement: c0stmt + "\n", console: cons, config: conf)
		printValue(value: c0, context: ctxt)

		return true
	}

	private func printValue(value val: JSValue?, context ctxt: KEContext){
		console.print(string: "\(String(describing: val?.description))\n")
	}
}


public func testValue(console cons: CNConsole, config conf: KEConfig) -> Bool
{
	let context  = KEContext(virtualMachine: JSVirtualMachine())
	let compiler = UTCompiler()
	return compiler.main(context: context, console: cons, config: conf)
}

