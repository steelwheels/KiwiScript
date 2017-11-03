/**
 * @file	main.swift
 * @brief	Main function for unit test
 * @par Copyright
 *	Copyright (C) 2017 Steel Wheels Project
 */

import KSStdLib
import Canary
import JavaScriptCore
import Foundation

let vm      = JSVirtualMachine()
let context = JSContext(virtualMachine: vm)!
let console = CNFileConsole()

context.exceptionHandler = { (context, value) in
	let desc: String
	if let v = value {
		desc = v.toString()
	} else {
		desc = "nil"
	}
	print("JavaScript Error: \(desc)")
}

private func compile(context ctxt: JSContext, script scr: String, console cons: CNConsole)
{
	cons.print(string: "Execute: \(scr)\n")
	if let retval = ctxt.evaluateScript(scr) {
		let retdesc = retval.description
		cons.print(string: " -> result: \(retdesc)\n")
	} else {
		cons.print(string: " -> result: nil\n")
	}

}

console.print(string: "*** Setup ***\n")
KSSetupStdLib(context: context, console: console)

/* standard console */
compile(context: context, script: "var a = 1 ; ", console: console)
compile(context: context, script: "print(\"Hello, world\");", console: console)
//compile(context: context, script: "error(\"This is error message.\");", console: console)

/* math */
let mathscr0 = "print(\"PI = \" + Math.PI);"
let mathscr1 = "print(\"sin(PI/2) = \" + Math.sin(Math.PI/2) + \"\\n\") ;"
let mathscr2 = "print(\"cos(PI/2) = \" + Math.cos(Math.PI/2) + \"\\n\") ;"

compile(context: context, script: mathscr0, console: console)
compile(context: context, script: mathscr1, console: console)
compile(context: context, script: mathscr2, console: console)

/*
var result = true
let console = CNFileConsole()

func test(_ flag : Bool){
	console.print(string: "RESULT : \(flag)\n")
	result = result && flag
}

func printTitle(title : String)
{
	
}

console.print(string: "* UTConsole\n")
test(testConsole())

console.print(string: "* UTMath\n")
test(testMath())

console.print(string: "**** SUMMARY\nTOTAL RESULT: ")
if result {
	console.print(string: "OK")
} else {
	console.print(string: "NG")
}
*/

