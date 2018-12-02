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
	public func main(context ctxt: KEContext) -> Bool {

		/* Bool */
		console.print(string: "/* Bool: true */\n")
		let b0 = self.compile(context: ctxt, statement: "b0 = true ;\n")
		printValue(value: b0, context: ctxt)

		/* Int */
		console.print(string: "/* Number: 123 */\n")
		let i0 = self.compile(context: ctxt, statement: "i0 = 123 ;\n")
		printValue(value: i0, context: ctxt)

		/* Float */
		console.print(string: "/* Number: 123.4 */\n")
		let f0 = self.compile(context: ctxt, statement: "f0 = 123.4 ;\n")
		printValue(value: f0, context: ctxt)

		/* String */
		console.print(string: "/* String: \"hello\" */\n")
		let s0 = self.compile(context: ctxt, statement: "s0 = \"hello\" ;\n")
		printValue(value: s0, context: ctxt)

		/* Array */
		console.print(string: "/* Array: [0, 1, 2, 3, 3.1] */\n")
		let a0 = self.compile(context: ctxt, statement: "a0 = [0, 1, 2, 3, 3.1] ;\n")
		printValue(value: a0, context: ctxt)

		/* Dictionary */
		console.print(string: "/* Dictionary: {a:0, b:1, c:2, d:3, e:3.1} */\n")
		let d0 = self.compile(context: ctxt, statement: "d0 = {a:0, b:1, c:2, d:3, e:3.1} ;\n")
		printValue(value: d0, context: ctxt)

		/* Dictionary */
		console.print(string: "/* Dictionary: {origin: {x:10.0, y:11.0}, size: {width:20.0, height: 21.0}} */\n")
		let d1 = self.compile(context: ctxt, statement: "d1 = {origin: {x:10.0, y:11.0}, size: {width:20.0, height: 21.0}};\n")
		printValue(value: d1, context: ctxt)

		return true
	}

	private func printValue(value val: JSValue?, context ctxt: KEContext){
		if let v = val {
			let type = v.type
			console.print(string: "* JSType = \(type.description)\n")

			/* Convert to native value */
			console.print(string: "* NativeValue = ")
			let ntval = v.toNativeValue()
			let nttxt = ntval.toText()
			nttxt.print(console: console)

			/* Backto JSValue */
			let jsval = ntval.toJSValue(context: ctxt)
			console.print(string: "* JSValue = \(jsval.description)\n")

		} else {
			console.print(string: "[Error] No value\n")
		}
	}
}


public func testValue(console cons: CNConsole, config conf: KEConfig) -> Bool
{
	let context  = KEContext(virtualMachine: JSVirtualMachine())
	let compiler = UTCompiler(console: cons, config: conf)
	return compiler.main(context: context)
}

