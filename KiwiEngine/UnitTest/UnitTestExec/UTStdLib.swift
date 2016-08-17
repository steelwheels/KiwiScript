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

func testStdLib() -> Bool
{
	var result  = true
	let console = CNTextConsole()
	
	let vm       = JSVirtualMachine()
	let context0 = KEContext(virtualMachine: vm)
	
	result = result && testPoint(context0, console: console)
	
	return result
}

private func testPoint(context : KEContext, console : CNConsole) -> Bool
{
	var summary = true
	
	
	let addptfunc =   "var incPoint = function(p0, p1){"
			+ " p0.x = p0.x + p1.x ; "
			+ " p0.y = p0.y + p1.y ; "
			+ "} ;"
	summary = summary && runScript(context, title: "add incPoint func", script: addptfunc)
	
	let srcpt0  = JSValue(point: CGPoint(x:0.1, y:0.2), inContext: context)
	let srcpt1  = JSValue(point: CGPoint(x:1.0, y:2.0), inContext: context)
	let srcargs = [srcpt0, srcpt1]
	let summary0 = callFunction("call incPoint func", context: context, funcionName: "incPoint", arguments: srcargs)
	if summary0 {
		dumpValue(console, value: srcpt0)
	}
	summary = summary && summary0

	return summary
}

private func runScript(context : KEContext, title : String, script : String) -> Bool
{
	var summary = true
	let (resultp, errorsp) = KEEngine.runScript(context, script: script)
	if let errors = errorsp {
		print("\(title) -> NG")
		dumpErrors(errors)
		summary = false
	} else {
		if let result = resultp {
			print("\(title) -> \(result)")
		} else {
			fatalError("can not happen")
		}
	}
	return summary
}

private func callFunction(title: String, context: KEContext, funcionName funcname: String, arguments: Array<AnyObject>) -> Bool
{
	var summary = true
	let (resultp, errorsp) = KEEngine.callFunction(context, functionName: funcname, arguments: arguments)
	if let errors = errorsp {
		print("\(title) -> NG")
		dumpErrors(errors)
		summary = false
	} else {
		if let result = resultp {
			print("\(title) -> \(result)")
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
		console.print(text: CNConsoleText(string: errmsg))
	} else if let str = encstr {
		let lines = str.componentsSeparatedByString("\n")
		console.print(text: CNConsoleText(strings: lines))
	} else {
		fatalError("Can not happen")
	}
}

private func dumpErrors(errors : Array<NSError>)
{
	for error in errors {
		print("\(error.toString())")
	}
}
