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
	var  isExecuting: Bool { get }
	func start(_ args: JSValue)
	func waitUntilExit() -> Int32
}

public class KHScriptThreadObject: CNThread
{
	public enum Script {
		case empty
		case script(String)
		case file(URL)
	}

	private var mContext:			KEContext
	private var mConfig:			KHConfig
	private var mResource:			KEResource

	private var mScript:			Script

	public var context: KEContext { get { return mContext }}

	public init(virtualMachine vm: JSVirtualMachine, script scr: Script, queue disque: DispatchQueue, input instrm: CNFileStream, output outstrm: CNFileStream, error errstrm: CNFileStream, environment env: CNEnvironment, resource res: KEResource, config conf: KHConfig){
		mContext 	= KEContext(virtualMachine: vm)
		mConfig		= conf
		mResource	= res
		mScript		= scr
		super.init(queue: disque, input: instrm, output: outstrm, error: errstrm, environment: env)

		/* Set initial home directory */
		let homedir = CNPreference.shared.userPreference.homeDirectory
		environment.currentDirectory = homedir

		/* Set exception handler */
		mContext.exceptionCallback = {
			[weak self]  (_ excep: KEException) -> Void in
			if let myself = self {
				myself.console.error(string: excep.description + "\n")
			}
		}
	}

	public override func main(arguments args: Array<CNNativeValue>) -> Int32 {
		if compile(config: mConfig) {
			return execOperation(arguments: args)
		} else {
			return -1
		}
	}

	private func compile(config conf: KEConfig) -> Bool {
		/* Compile the context */
		let compiler = KHShellCompiler()
		guard compiler.compileBaseAndLibrary(context: mContext, queue: super.queue, environment: self.environment, resource: mResource, console: self.console, config: conf) else {
			console.error(string: "Failed to compile script thread context\n")
			return false
		}

		/* Make script */
		let script: String
		switch mScript {
		case .file(let url):
			if let scr = url.loadContents() {
				script = String(scr)
			} else {
				return false
			}
		case .script(let scr):
			script = scr
		case .empty:
			console.error(string: "No script")
			return false
		}
		let _ = compiler.compile(context: mContext, statement: script, console: console, config: conf)
		return true
	}

	private func execOperation(arguments args: Array<CNNativeValue>) -> Int32 {
		/* Search main function */
		var result: Int32 = -1
		if let funcval = mContext.getValue(name: "main") {
			/* Allocate argument */
			var jsarr: Array<JSValue> = []
			for arg in args {
				jsarr.append(arg.toJSValue(context: mContext))
			}
			if let jsarg = JSValue(object: jsarr, in: mContext) {
				/* Call main function */
				if let retval = funcval.call(withArguments: [jsarg]) {
					result = retval.toInt32()
				} else {
					self.console.error(string: "Failed to call main function\n")
				}
			} else {
				self.console.error(string: "Failed to covert argument\n")
			}
		} else {
			self.console.error(string: "main function is NOT found\n")
		}
		return result
	}
}

@objc public class KHScriptThread: NSObject, KHThreadProtocol
{
	public typealias Script = KHScriptThreadObject.Script

	private var mThread:	KHScriptThreadObject

	public init(virtualMachine vm: JSVirtualMachine, script scr: Script, queue disque: DispatchQueue, input instrm: CNFileStream, output outstrm: CNFileStream, error errstrm: CNFileStream, environment env: CNEnvironment, resource res: KEResource, config conf: KHConfig){
		mThread = KHScriptThreadObject(virtualMachine: vm, script: scr, queue: disque, input: instrm, output: outstrm, error: errstrm, environment: env, resource: res, config: conf)
	}

	public var isExecuting:	Bool  { get { return mThread.isRunning }}
	public var context: KEContext { get { return mThread.context   }}

	public func start(arguments args: Array<CNNativeValue>) {
		mThread.start(arguments: args)
	}

	public func start(_ args: JSValue){
		let nargs = args.toNativeValue()
		mThread.start(arguments: [nargs])
	}

	public func waitUntilExit() -> Int32 {
		return mThread.waitUntilExit()
	}
}


