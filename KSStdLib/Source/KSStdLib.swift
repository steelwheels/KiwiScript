/**
 * @file	KSStdLib.swift
 * @brief	Function to register the KSStdLib library into the user program
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation
import JavaScriptCore
import Canary

public func KSSetupStdLib(context ctxt: JSContext, console cons: CNConsole)
{
	/* console */
	KSSetupStdConsole(context: ctxt, console: cons)
	/* math */
	let mathobj = KSMath(context: ctxt)
	ctxt.setObject(mathobj, forKeyedSubscript: NSString(string: "Math"))
}

private func KSSetupStdConsole(context ctxt: JSContext, console cons: CNConsole)
{
	/* "print" method */
	let printmethod: @convention(block) (_ srcvalue: JSValue) -> JSValue = {
		(_ srcvalue: JSValue) -> JSValue in
		let desc = srcvalue.description
		cons.print(string: desc)
		return JSValue(uInt32: UInt32(desc.count), in: ctxt)
	}
	ctxt.setObject(printmethod, forKeyedSubscript: NSString(string: "print"))

	/* "error" method */
	let errormethod: @convention(block) (_ srcvalue: JSValue) -> JSValue = {
		(_ srcvalue: JSValue) -> JSValue in
		let desc = srcvalue.description
		cons.error(string: desc)
		return JSValue(uInt32: UInt32(desc.count), in: ctxt)
	}
	ctxt.setObject(errormethod, forKeyedSubscript: NSString(string: "error"))
}




