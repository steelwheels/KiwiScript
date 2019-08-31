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

@objc public class KHScriptThread: CNPipeThread, KHThreadProtocol
{
	public static let EnvironmentItem	= "_env"

	private var mContext:			KEContext
	private var mScripts:			Array<URL>
	private var mArguments:			Array<String>
	private var mTerminationStatus:		Int32

	public init(virtualMachine vm: JSVirtualMachine, shellInterface intf: CNShellInterface, environment env: CNShellEnvironment, console cons: CNConsole, config conf: KHConfig){
		mContext		= KEContext(virtualMachine: vm)
		mScripts		= []
		mArguments		= []
		mTerminationStatus	= 1
		super.init(interface: intf, environment: env, console: cons, config: conf)

		/* Compile the context */
		let compiler = KHShellCompiler()
		guard compiler.compile(context: mContext, environment: env, console: cons, config: conf) else {
			cons.error(string: "Failed to compile script thread context\n")
			return
		}
	}

	public override var terminationStatus: Int32 {
		get { return mTerminationStatus }
	}

	public func start(userScripts scripts: Array<URL>, arguments args: Array<String>) {
		mScripts   = scripts
		mArguments = args
		super.start()
	}

	public override func main() {
		guard let conf = config as? KHConfig else {
			NSLog("Can not happen")
			return
		}

		/* Compile user scripts */
		let compiler = KHShellCompiler()
		guard compiler.compile(context: mContext, sourceFiles: mScripts, console: console, config: conf) else {
			console.error(string: "Failed to compile  user scripts")
			mTerminationStatus = 1
			return
		}

		/* Execute main function */
		if conf.hasMainFunction {
			/* Call main function */
			mTerminationStatus = 1
			if let mainfunc = mContext.objectForKeyedSubscript("main") {
				if let retval = mainfunc.call(withArguments: [mArguments]) {
					if retval.isNumber {
						mTerminationStatus = retval.toInt32()
					}
				} else {
					console.error(string: "[Error] No Return value.\n")
				}
			} else {
				console.error(string: "Can not find main function.\n")
			}
		} else {
			mTerminationStatus = 0
		}
	}
}

