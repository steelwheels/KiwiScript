/**
 * @file	main.swift
 * @brief	Main function for unit test
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiObject
import KiwiLibrary
import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

public func main()
{
	let config = KLConfig(kind: .Terminal, doStrict: true, doVerbose: true)

	let console = CNFileConsole()
	let context = KEContext(virtualMachine: JSVirtualMachine())
	let process = KEProcess(context: context, config: config)

	let compiler = KLCompiler(console: console, config: config)
	if compiler.compile(context: context, process: process) {
		console.error(string: "Compile: OK\n")
	} else {
		console.error(string: "Compile: NG\n")
		return
	}

	let result0 = testApplication(context: context, config: config, console: console)

	let result = result0
	if result {
		console.print(string: "Summary: OK\n")
	} else {
		console.print(string: "Summary: NG\n")
	}
}

func test(funcName fn:String, result res:Bool, console cons: CNConsole) -> Bool
{
	if(res){
		cons.print(string: "\(fn) : OK\n")
	} else {
		cons.print(string: "\(fn) : NG\n")
	}
	return res
}

main()


