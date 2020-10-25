/**
 * @file	KLThread.swift
 * @brief	Define KLThread class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation

@objc public protocol KLThreadProtocol: JSExport {
	func start(_ args: JSValue)
	func isRunning() -> Bool
	func waitUntilExit() -> Int32
	func terminate()
}

@objc open class KLThread: CNThread, KLThreadProtocol
{
	private enum SourceFile {
		case application(KEResource)
		case resource(String, KEResource)	// thread-name, resource
		case file(URL)				// URL of source file
	}

	private var mContext:			KEContext
	private var mResource:			KEResource
	private var mChildProcessManager:	CNProcessManager
	private var mSourceFile:		SourceFile
	private var mTerminalInfo:		CNTerminalInfo
	private var mConfig:			KEConfig
	private var mExceptionCount:		Int

	public var context: KEContext { get { return mContext }}

	public init(threadName thname: String?, resource res: KEResource, processManager procmgr: CNProcessManager, input instrm: CNFileStream, output outstrm: CNFileStream, error errstrm: CNFileStream, environment env: CNEnvironment, config conf: KEConfig) {
		let vm			= JSVirtualMachine()
		mContext   		= KEContext(virtualMachine: vm!)
		mResource		= res
		mChildProcessManager	= CNProcessManager()
		if let name = thname {
			mSourceFile	= .resource(name, res)
		} else {
			mSourceFile	= .application(res)
		}
		mTerminalInfo		= CNTerminalInfo(width: 80, height: 25)
		mConfig			= KEConfig(applicationType: conf.applicationType,
						   doStrict: conf.doStrict,
						   logLevel: conf.logLevel)
		mExceptionCount		= 0
		super.init(processManager: procmgr, input: instrm, output: outstrm, error: errstrm, environment: env)

		/* Add to parent manager */
		procmgr.addChildManager(childManager: mChildProcessManager)
	}

	public init(scriptURL scrurl: URL, processManager procmgr: CNProcessManager, input instrm: CNFileStream, output outstrm: CNFileStream, error errstrm: CNFileStream, environment env: CNEnvironment, config conf: KEConfig) {
		let vm			= JSVirtualMachine()
		mContext   		= KEContext(virtualMachine: vm!)
		mResource		= KEResource(singleFileURL: scrurl)
		mChildProcessManager	= CNProcessManager()
		mSourceFile		= .file(scrurl)
		mTerminalInfo		= CNTerminalInfo(width: 80, height: 25)
		mConfig			= KEConfig(applicationType: conf.applicationType,
						   doStrict: conf.doStrict,
						   logLevel: conf.logLevel)
		mExceptionCount		= 0
		super.init(processManager: procmgr, input: instrm, output: outstrm, error: errstrm, environment: env)

		/* Add to parent manager */
		procmgr.addChildManager(childManager: mChildProcessManager)
	}

	public func start(_ args: JSValue) {
		let nargs = args.toNativeValue()
		super.start(argument: nargs)
	}

	public override func main(argument arg: CNNativeValue) -> Int32 {
		if setup(processManager: mChildProcessManager, config: mConfig) {
			return execOperation(argument: arg)
		} else {
			return -1
		}
	}

	private func setup(processManager procmgr: CNProcessManager, config conf: KEConfig) -> Bool {
		/* Set exception handler */
		mContext.exceptionCallback = {
			[weak self]  (_ excep: KEException) -> Void in
			if let myself = self {
				myself.console.error(string: excep.description + "\n")
				myself.mExceptionCount += 1
			}
		}

		/* Compile */
		guard compile(context: mContext, resource: mResource, processManager: mChildProcessManager, terminalInfo: mTerminalInfo, environment: self.environment, console: self.console, config: mConfig) else {
			console.error(string: "Compile error")
			return false
		}

		/* Load main script */
		let script: String?
		switch mSourceFile {
		case .application(let res):
			script = res.loadApplication()
		case .file(let url):
			if let scr = url.loadContents() {
				script = scr as String
			} else {
				console.error(string: "Failed to load contents: \(url.absoluteString)\n")
				script = nil
			}
		case .resource(let thname, let res):
			if let scr = res.loadThread(identifier: thname) {
				script = scr
			} else {
				console.error(string: "Failed to load from resource: name=\(thname)\n")
				script = nil
			}
		}

		/* Execute the script */
		if let scr = script {
			let compiler = KECompiler()
			let _ = compiler.compile(context: mContext, statement: scr, console: console, config: conf)
		} else {
			//console.error(string: "Failed to load script\n")
			//mResource.toText().print(console: console, terminal: ",")
			return false
		}
		return true
	}

	open func compile(context ctxt: KEContext, resource res: KEResource, processManager procmgr: CNProcessManager, terminalInfo terminfo: CNTerminalInfo, environment env: CNEnvironment, console cons: CNFileConsole, config conf: KEConfig) -> Bool {
		let compiler = KLCompiler()
		guard compiler.compileBase(context: ctxt, terminalInfo: terminfo, environment: env, console: cons, config: conf) else {
			return false
		}
		guard compiler.compileLibrary(context: ctxt, resource: res, processManager: procmgr, environment: env, console: cons, config: conf) else {
			return false
		}
		return true
	}

	private func pathExtension(of file: String) -> String {
		let strobj = NSString(string: file)
		return strobj.pathExtension
	}

	private func loadScript(from url: URL) -> String? {
		do {
			return try String(contentsOf: url)
		} catch {
			return nil
		}
	}

	private func execOperation(argument arg: CNNativeValue) -> Int32 {
		/* Search main function */
		var result: Int32 = -1
		if let funcval = mContext.getValue(name: "main") {
			/* Allocate argument */
			let jsarg = arg.toJSValue(context: mContext)
			/* Call main function */
			if let retval = funcval.call(withArguments: [jsarg]) {
				let retval = retval.toInt32()
				if retval == 0 && mExceptionCount == 0 {
					result = 0
				}
			} else {
				self.console.error(string: "Failed to call main function\n")
			}
		} else {
			self.console.error(string: "main function is NOT found\n")
		}
		return result
	}

	public func isRunning() -> Bool {
		return super.isRunning
	}

	open override func terminate() {
		super.terminate()
	}

	public override func waitUntilExit() -> Int32 {
		return super.waitUntilExit()
	}
}
