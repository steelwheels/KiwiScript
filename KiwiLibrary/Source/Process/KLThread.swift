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

public class KLThreadObject: CNThread
{
	public enum SourceFile {
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
		super.init(processManager: procmgr, input: instrm, output: outstrm, error: errstrm, environment: env)

		/* Add to parent manager */
		procmgr.addChildManager(childManager: mChildProcessManager)
	}

	public override func main(argument arg: CNNativeValue) -> Int32 {
		if compile(processManager: mChildProcessManager, config: mConfig) {
			return execOperation(argument: arg)
		} else {
			return -1
		}
	}

	private func compile(processManager procmgr: CNProcessManager, config conf: KEConfig) -> Bool {
		/* Compile */
		let compiler = KLCompiler()
		guard compiler.compileBase(context: mContext, terminalInfo: self.mTerminalInfo, environment: self.environment, console: self.console, config: conf) else {
			return false
		}
		guard compiler.compileLibrary(context: mContext, resource: mResource, processManager: procmgr, environment: self.environment, console: self.console, config: conf) else {
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
				script = nil
			}
		case .resource(let thname, let res):
			script = res.loadThread(identifier: thname)
		}

		if let scr = script {
			let _ = compiler.compile(context: mContext, statement: scr, console: console, config: conf)
		} else {
			console.error(string: "Failed to load script\n")
			mResource.toText().print(console: console, terminal: ",")
			return false
		}
		return true
	}

	private var mDidSelected : Bool = false
	private var mSelectedURL : URL? = nil

	private func selectInputFile() -> URL? {
		mSelectedURL	= nil
		mDidSelected	= false
		#if os(OSX)
		switch mConfig.applicationType {
		case .window:
			/* open panel to select */
			CNExecuteInMainThread(doSync: false, execute: {
				URL.openPanelWithAsync(title: "Select script to execute", selection: .SelectFile, fileTypes: ["js", "jspkg"], callback: {
					(_ urls: Array<URL>) -> Void in
					if urls.count >= 1 {
						self.mSelectedURL = urls[0]
					}
					self.mDidSelected = true
				})
			})
			while !self.mDidSelected {
				usleep(100)
			}
		case .terminal:
			break
		@unknown default:
			break
		}
		#endif
		return self.mSelectedURL
	}

	/*
	private func loadSourceFile(from url: URL, processManager procmgr: CNProcessManager, config conf: KEConfig) -> String? {
		let result: String?
		switch pathExtension(of: url.path) {
		case "js":
			result = loadScript(from: url)
		case "jspkg":
			let res = KEResource(baseURL: url)
			let srcfile: KESourceFile = .resource(res)
			/* Compile */
			let compiler = KLCompiler()
			guard compiler.compileBase(context: mContext, terminalInfo: self.mTerminalInfo, environment: self.environment, console: self.console, config: conf) else {
				return nil
			}
			guard compiler.compileLibrary(context: mContext, sourceFile: srcfile, processManager: procmgr, environment: self.environment, console: self.console, config: conf) else {
				return nil
			}
			result = res.loadApplication()
		default:
			result = nil
		}
		return result
	}*/

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
				result = retval.toInt32()
			} else {
				self.console.error(string: "Failed to call main function\n")
			}
		} else {
			self.console.error(string: "main function is NOT found\n")
		}
		return result
	}
}

@objc public class KLThread: NSObject, KLThreadProtocol
{
	private var mThread: KLThreadObject

	public init(thread threadobj: KLThreadObject) {
		mThread = threadobj
	}

	public func start(_ arg: JSValue) {
		let nval = arg.toNativeValue()
		mThread.start(argument: nval)
	}

	public func isRunning() -> Bool {
		return mThread.isRunning
	}

	public func waitUntilExit() -> Int32 {
		return mThread.waitUntilExit()
	}

	public func terminate() {
		return mThread.terminate()
	}

	public func print(string str: String) {
		mThread.outputFileHandle.write(string: str)
	}

	public func error(string str: String) {
		mThread.errorFileHandle.write(string: str)
	}
}

