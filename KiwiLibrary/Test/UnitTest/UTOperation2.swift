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

public func UTOperation2(console cons: CNConsole, config conf: KEConfig) -> Bool
{
	var result  = true

	let ctxt     = KEContext(virtualMachine: JSVirtualMachine())
	let compiler = KLCompiler(console: cons, config: conf)
	if compiler.compile(context: ctxt) {
		cons.error(string: "MainThread: Compile OK\n")
	} else {
		cons.error(string: "MainThread: Compile failed\n")
		result = false
	}

	let opconf = KEConfig(kind: .Operation, doStrict: true, doVerbose: true)
	let op     = KLOperation(ownerContext: ctxt, console: cons, config: opconf)

	let program =
		"class Machine extends Operation {\n" +
		"  constructor(){\n" +
	        "    super();\n" +
		"    this.kind   = 0 ;\n" +
		"    this.object = null ;\n" +
		"  }\n" +
		"  set(command, value){\n" +
		"    this.print(command, value) ;\n" +
		"    this.kind   = command ;\n" +
		"    this.object = value ;\n" +
		"  }\n" +
		"\n" +
		"  main(){\n" +
		"    console.log(\"Operaion: main function\\n\");\n" +
		"    this.print(this.kind, this.object) ;\n" +
 		"  }\n" +
		"\n" +
		"  print(kind, object){\n" +
		"    if(kind == 0){\n" +
		"      console.log(\"Operation: command = \" + kind + \", value = \" + object + \"\\n\") ;\n" +
		"    } else if(kind == 1){\n" +
		"      console.log(\"Operation: command = \" + kind + \", value = \" + object.size().width + \"\\n\") ;\n" +
		"    } else if(kind == 2){\n" +
		"      console.log(\"Operation: command = \" + kind + \", value = \" + object.url.absoluteString + \"\\n\") ;\n" +
		"    }\n" +
		"  }\n" +
		"} ;\n" +
		"operation = new Machine(); \n"
	let retval = op.compile(JSValue(object: program, in: ctxt))
	if retval.isBoolean {
		if retval.toBool() {
			cons.print(string: "MainThread: [Compile] OK\n")
		} else {
			cons.error(string: "MainThread: [Error] compile failed\n")
			result = false
		}
	} else {
		cons.error(string: "MainThread: [Error] boolean value is required\n")
		result = false
	}

	cons.print(string: "* Test1\n")
	opSet(operation: op, command: 0, value: JSValue(bool: true, in: ctxt), context: ctxt, console: cons)

	cons.print(string: "* Test2\n")
	if let val = ctxt.evaluateScript("val = {a:10, b:20};") {
		opSet(operation: op, command: 0, value: val, context: ctxt, console: cons)
	}

	cons.print(string: "* Test3\n")
	let img = KLImage(context: ctxt)
	opSet(operation: op, command: 1, value: JSValue(object: img, in: ctxt), context: ctxt, console: cons)

	cons.print(string: "* Test4\n")
	if let val = ctxt.evaluateScript("val = { url: URL(\"http://steelwheels.com\") } ;") {
		opSet(operation: op, command: 2, value: val, context: ctxt, console: cons)
	}

	cons.print(string: "* Test5\n")
	let queue   = KLOperationQueue(console: cons)
	let opval   = JSValue(object: op, in: ctxt)
	let limval  = JSValue(nullIn: ctxt)
	let retval2  = queue.execute(opval!, limval!)
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
	queue.waitOperations()
	
	return result
}

private func opSet(operation op: KLOperation, command cmd: Int, value val: JSValue, context ctxt: KEContext, console cons: CNConsole)
{
	if let cmdval = JSValue(int32: Int32(cmd), in: ctxt) {
		cons.print(string: "MainThread: Set command: \(cmd)\n")
		op.set(cmdval, val)
	} else {
		cons.error(string: "MainThread: [Error] Failed to set command: \(cmd)\n")
	}
}
