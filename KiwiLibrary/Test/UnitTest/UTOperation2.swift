/*
 * @file	UTOperation2.swift
 * @brief	Unit test for KLOperation class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import KiwiLibrary
import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

public func UTOperation2(console cons: CNFileConsole, config conf: KEConfig) -> Bool
{
	var result  = true

	let ctxt     = KEContext(virtualMachine: JSVirtualMachine())
	let env	     = CNEnvironment()
	let compiler = KLCompiler()
	if compiler.compileBase(context: ctxt, environment: env, console: cons, config: conf) {
		cons.print(string: "MainThread: Compile OK\n")
	} else {
		cons.print(string: "MainThread: Compile failed\n")
		result = false
	}

	let opconf = KEConfig(applicationType: .terminal, doStrict: true, logLevel: .detail)
	let op     = KLOperationContext(ownerContext: ctxt,
					libraries: [],
					input:  cons.inputHandle,
					output: cons.outputHandle,
					error:  cons.errorHandle,
					environment: env,
					config: opconf)

	switch CNFilePath.URLForBundleFile(bundleName: "UnitTest", fileName: "unit-test-1", ofType: "js") {
	case .ok(let url):
		if op.compile(userStructs:[], userScripts: [url]) {
			cons.print(string: "MainThread: [Compile] OK\n")
		} else {
			cons.print(string: "MainThread: [Error] compile failed\n")
		}
	case .error(let err):
		cons.error(string: "[Error] \(err.description)")
	}

	cons.print(string: "* Test1\n")
	let boolval = CNNativeValue.numberValue(NSNumber(booleanLiteral: true))
	opSet(operation: op, parameter: "param0", value: boolval, console: cons)

	cons.print(string: "* Test3\n")
	let img    = CNImage(byReferencing: URL(fileURLWithPath: "https://github.com/steelwheels/Amber/blob/master/Document/Images/AmberLogo.png"))
	let imgval = CNNativeValue.imageValue(img)
	opSet(operation: op, parameter: "param2", value: imgval, console: cons)

	cons.print(string: "* Test5\n")
	let queue   = KLOperationQueue(context: ctxt, console: cons)
	let opval   = JSValue(object: op, in: ctxt)
	let limval  = JSValue(nullIn: ctxt)
	let retval2  = queue.execute(opval!, limval!)
	queue.waitOperations()
	if retval2.isBoolean {
		if retval2.toBool() {
			cons.print(string: "exec result: OK\n")
		} else {
			cons.error(string: "exec result: OK\n")
			result = false
		}
	} else {
		cons.error(string: "Invalid return value type\n")
		result = false
	}

	return result
}

private func opSet(operation op: KLOperationContext, parameter param: String, value val: CNNativeValue, console cons: CNConsole)
{
	let text = val.toText()
	cons.print(string: "MainThread: Set command: \(param) <- ")
	text.print(console: cons)
	op.setParameter(name: param, value: val)
}
