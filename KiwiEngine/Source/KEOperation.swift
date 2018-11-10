/**
 * @file	KEOperation.swift
 * @brief	Extend KEOperation class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import CoconutData
import JavaScriptCore
import Foundation

private class KEOperationCompiler: KECompiler
{
	public func compile(context ctxt: KEContext, operationObject obj: KEOperationObject, fileName fname: String) -> Bool {
		log(string: "/* Compile Operation object */\n")
		ctxt.set(name: "Operation", object: obj)

		/* Compile the object */
		super.compile(context: ctxt, instance: "Operation", object: obj)
		
		/* Add listener function */
		let listnerstmt = "Operation.addListener(\"isCanceled\", function(value){\n" +
				  "  if(value){ cancel(1) ; }\n" +
				  "}) ;\n"
		let _ = compile(context: ctxt, statement: listnerstmt)

		/* Read source script */
		guard let script = super.readUserScript(scriptFile: fname) else {
			NSLog("[Error] Failed to compile \"\(fname)\" at \(#function)")
			return false
		}
		let _ = compile(context: ctxt, statement: script)

		return true
	}
}

public class KEOperation: Operation
{
	private var mContext:		KEContext
	private var mOperationObject:	KEOperationObject
	private var mConsole:		CNConsole
	private var mConfig:		KEConfig
	private var mExecName:		String?
	private var mMainName:		String?
	private var mArguments:		Array<JSValue>?
	private var mResult:		JSValue?

	public init(virtualMachine vm: JSVirtualMachine, console cons: CNConsole, config conf: KEConfig){
		mContext		= KEContext(virtualMachine: vm)
		mOperationObject	= KEOperationObject(context: mContext)
		mConsole		= cons
		mConfig			= conf
		mExecName		= nil
		mMainName		= nil
		mArguments		= nil
		mResult			= nil
		super.init()
	}

	public override var isAsynchronous: Bool {
		get { return true }
	}

	public override var isFinished: Bool {
		get          { return mOperationObject.isFinished	}
		set (newval) { mOperationObject.isFinished = newval 	}
	}

	public override var isExecuting: Bool {
		get	     { return mOperationObject.isExecuting	}
		set (newval) { mOperationObject.isExecuting = newval 	}
	}

	public override var isCancelled: Bool {
		get	     { return mOperationObject.isCanceled	}
		set (newvao) { mOperationObject.isCanceled = true 	}
	}

	public func compile(fileName fname: String) -> Bool {
		/* setup the context */
		let compiler = KEOperationCompiler(console: mConsole, config: mConfig)
		return compiler.compile(context: mContext, operationObject: mOperationObject, fileName: fname)
	}

	public func set(mainName mname: String, arguments args: Array<JSValue>){
		mMainName	= mname
		mArguments	= args
	}

	public override func main() {
		/* Start execution */
		isExecuting	= true
		isFinished	= false

		/* Call main function */
		mResult = callStartup()

		/* Finish execution */
		isExecuting	= false
		isFinished	= true
	}

	private func callStartup() -> JSValue? {
		if let mainname = mMainName, let args = mArguments {
			if let mainval = mContext.objectForKeyedSubscript(mainname) {
				if let startval = mContext.objectForKeyedSubscript("_exec_cancelable") {
					return startval.call(withArguments: [mainval, args])
				}
			}
		}
		return nil
	}

	public override func cancel() {
		mOperationObject.isCanceled = true
		super.cancel()
	}
}

