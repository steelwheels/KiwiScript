/**
 * @file	KHScriptThread.swift
 * @brief	Define KHScriptThread class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutShell
import CoconutData
import KiwiEngine
import KiwiLibrary
import JavaScriptCore
import Foundation

@objc public protocol KHThreadProtocol: JSExport
{
	var  isExecuting:	Bool { get }
	func start()
}

@objc public class KHScriptThread: CNThread, KHThreadProtocol
{
	public static let EnvironmentItem	= "_env"

	private var mContext:			KEContext
	private var mConfig:			KHConfig
	private var mStatements:		Array<String>
	private var mArguments:			Array<String>
	private var mResultValue:		Int32?

	open override var terminationStatus: Int32 { get {
		if let val = mResultValue {
			return val
		} else {
			return super.terminationStatus
		}
	}}

	public init(virtualMachine vm: JSVirtualMachine, resource res: KEResource, input instrm: CNFileStream, output outstrm: CNFileStream, error errstrm: CNFileStream, config conf: KHConfig){
		mContext		= KEContext(virtualMachine: vm)
		mConfig			= conf
		mStatements		= []
		mArguments		= []
		mResultValue		= nil
		super.init(input: instrm, output: outstrm, error: errstrm, terminationHander: nil)

		/* Compile the context */
		let compiler = KHShellCompiler()
		guard compiler.compileBaseAndLibrary(context: mContext, resource: res, console: self.console, config: conf) else {
			console.error(string: "Failed to compile script thread context\n")
			return
		}
		/* Set exception handler */
		mContext.exceptionCallback = {
			[weak self]  (_ excep: KEException) -> Void in
			if let myself = self {
				myself.console.error(string: excep.description + "\n")
			}
		}
	}

	public func start(statements stmts: Array<String>, arguments args: Array<String>) {
		mStatements	= stmts
		mArguments 	= args
		super.start()
	}

	public override func mainOperation() -> Int32 {
		/* Initialize */
		mResultValue = nil

		/* Compile user scripts */
		let compiler = KHShellCompiler()
		let _ = compiler.compile(context: mContext, statements: mStatements, console: console, config: mConfig)
		if mContext.errorCount != 0 {
			console.error(string: "Failed to compile  user scripts")
			return -1
		}

		/* Execute main function */
		var result: Int32 = 0
		if mConfig.hasMainFunction {
			/* Call main function */
			if let mainfunc = mContext.objectForKeyedSubscript("main") {
				if let retval = mainfunc.call(withArguments: [mArguments]) {
					if retval.isNumber {
						result = retval.toInt32()
					}
				} else {
					console.error(string: "[Error] No Return value.\n")
				}
			} else {
				console.error(string: "Can not find main function.\n")
			}
		}
		mResultValue = result
		return result
	}
}

