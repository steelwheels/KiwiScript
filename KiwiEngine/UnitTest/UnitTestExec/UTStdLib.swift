/**
 * @file	UTStdLib.swift
 * @brief	Unit test for KSStdLib framework
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation
import KiwiEngine
import KSStdLib
import JavaScriptCore
import Canary

func testStdLib(console cons: CNConsole) -> Bool
{
	var result  = true
	let console = CNFileConsole(file: CNTextFile.stdout)

	let vm       = JSVirtualMachine()
	let context0 = KEContext(virtualMachine: vm)

	result = result && testPoint(console: cons, context: context0, console: console)

	return result
}

private func testPoint(console cons: CNConsole, context : KEContext, console : CNConsole) -> Bool
{
	var summary = true

	let addptfunc =   "var incPoint = function(p0, p1){"
			+ " p0.x = p0.x + p1.x ; "
			+ " p0.y = p0.y + p1.y ; "
			+ "} ;"
	summary = summary && runScript(console: cons, context: context, title: "add incPoint func", script: addptfunc)

	let srcpt0  = JSValue(point: CGPoint(x:0.1, y:0.2), in: context)
	let srcpt1  = JSValue(point: CGPoint(x:1.0, y:2.0), in: context)
	if let spt0 = srcpt0, let spt1 = srcpt1 {
		let srcargs = [spt0, spt1]
		let summary0 = callFunction(console: cons, title: "call incPoint func", context: context, funcionName: "incPoint", arguments: srcargs)
		if summary0 {
			dumpValue(console: console, value: spt0)
		}
		summary = summary && summary0
	} else {
		console.print(string: "[Error] Can not allocate JSValue\n")
		summary = false
	}
	return summary
}

private func runScript(console : CNConsole, context : KEContext, title : String, script : String) -> Bool
{
	var summary = true
	let (resultp, errorsp) = KEEngine.runScript(context: context, script: script)
	if let errors = errorsp {
		console.print(string: "\(title) -> NG\n")
		dumpErrors(errors: errors)
		summary = false
	} else {
		if let result = resultp {
			console.print(string: "\(title) -> \(result)\n")
		} else {
			fatalError("can not happen")
		}
	}
	return summary
}

private func callFunction(console : CNConsole, title: String, context: KEContext, funcionName funcname: String, arguments: Array<AnyObject>) -> Bool
{
	var summary = true
	let (resultp, errorsp) = KEEngine.callFunction(context: context, functionName: funcname, arguments: arguments)
	if let errors = errorsp {
		console.print(string: "\(title) -> NG\n")
		dumpErrors(errors: errors)
		summary = false
	} else {
		if let result = resultp {
			console.print(string: "\(title) -> \(result)\n")
		} else {
			fatalError("Can not happen")
		}
	}
	return summary
}

private func dumpValue(console : CNConsole, value : JSValue)
{
	let encdict = KSValueCoder.encode(value: value)
	let (encstr, encerr)  = CNJSONFile.serialize(dictionary: encdict)
	if let error = encerr {
		let errmsg = "[Error] " + error.toString()
		console.print(string: errmsg)
	} else if let str = encstr {
		let lines = str.components(separatedBy: "\n")
		for str in lines {
			console.print(string: str)
		}
	} else {
		fatalError("Can not happen")
	}
}

private func dumpErrors(errors : Array<String>)
{
	for error in errors {
		print("\(error)\n")
	}
}
