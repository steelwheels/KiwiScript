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

func testStdLib() -> Bool
{
	var result  = true
	
	let engine  = KEEngine()
	
	result = result && testPoint(engine)
	
	return result
}

private func testPoint(engine : KEEngine) -> Bool
{
	var summary = true
	
	
	let addptfunc =   "var incPoint = function(p0, p1){"
			+ " p0.x = p0.x + p1.x ; "
			+ " p0.y = p0.y + p1.y ; "
			+ "} ;"
	summary = summary && runScript("add incPoint func", engine: engine, script: addptfunc)
	
	let srcpt0  = JSValue(point: CGPoint(x:0.1, y:0.2), inContext: engine.context())
	let srcpt1  = JSValue(point: CGPoint(x:1.0, y:2.0), inContext: engine.context())
	let srcargs = [srcpt0, srcpt1]
	let summary0 = callFunction("call incPoint func", engine: engine, funcname: "incPoint", arguments: srcargs)
	if summary0 {
		dumpValue(srcpt0)
	}
	summary = summary && summary0

	return summary
}

private func runScript(title : String, engine : KEEngine, script : String) -> Bool
{
	var summary = true
	let (result, errors) = engine.runScript(script)
	if let resval = result {
		print("\(title) -> \(resval)")
	} else {
		print("\(title) -> NG")
		dumpErrors(errors)
		summary = false
	}
	return summary
}

private func callFunction(title: String, engine: KEEngine, funcname: String, arguments: Array<AnyObject>) -> Bool
{
	var summary = true
	let (result, errors) = engine.callFunction(funcname, arguments: arguments)
	if let resval = result {
		print("\(title) -> \(resval)")
	} else {
		print("\(title) -> NG")
		dumpErrors(errors)
		summary = false
	}
	return summary
}

private func dumpValue(value : JSValue)
{
	let encoder = KSJsonEncoder()
	let buf = encoder.encode(value)
	buf.dump()
}

private func dumpErrors(errors : Array<NSError>)
{
	for error in errors {
		print("\(error.toString())")
	}
}
