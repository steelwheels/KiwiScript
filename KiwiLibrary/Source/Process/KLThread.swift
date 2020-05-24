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
	public typealias ScriptFile = KLThread.ScriptFile

	private var mContext:			KEContext
	private var mChildProcessManager:	CNProcessManager
	private var mScriptFile:		ScriptFile
	private var mTerminalInfo:		CNTerminalInfo
	private var mResource:			KEResource
	private var mConfig:			KEConfig

	public init(virtualMachine vm: JSVirtualMachine, scriptFile file: ScriptFile, processManager procmgr: CNProcessManager, input instrm: CNFileStream, output outstrm: CNFileStream, error errstrm: CNFileStream, environment env: CNEnvironment, resource res: KEResource, config conf: KEConfig) {
		mContext   		= KEContext(virtualMachine: vm)
		mChildProcessManager	= CNProcessManager()
		mScriptFile		= file
		mTerminalInfo		= CNTerminalInfo(width: 80, height: 25)
		mResource		= res
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
		guard compiler.compileLibraryInResource(context: mContext, processManager: procmgr, environment: self.environment, resource: mResource, console: self.console, config: conf) else {
			return false
		}
		/* Load script */
		let script: String?
		switch mScriptFile {
		case .identifier(let ident):
			script = mResource.loadScript(identifier: ident, index: 0)
		case .url(let url):
			script = loadScript(from: url)
		case .script(let scr):
			script = scr
		case .unselected:
			if let url = selectInputFile() {
				script = loadMainScript(from: url)
			} else {
				console.error(string: "Failed to select script")
				return false
			}
		}
		if let scr = script {
			let _ = compiler.compile(context: mContext, statement: scr, console: console, config: conf)
		} else {
			console.error(string: "Failed to load script: \(mScriptFile.description())")
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
		}
		#endif
		return self.mSelectedURL
	}

	private func loadMainScript(from url: URL) -> String? {
		let result: String?
		switch pathExtension(of: url.path) {
		case "js":
			result = loadScript(from: url)
		case "jspkg":
			let res = KEResource(baseURL: url)
			result = res.loadScript(identifier: "main", index: 0)
		default:
			result = nil
		}
		return result
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
	public enum ScriptFile {
		case identifier(String)		// script indentifier in package file
		case url(URL)			// URL of external file
		case script(String)		// JavaScript code
		case unselected			// Not selected yet

		func description() -> String {
			let result: String
			switch self {
			case .identifier(let ident):
				result = ident
			case .url(let url):
				result = url.path
			case .script(_):
				result = "<javascript-code>"
			case .unselected:
				result = "<not defined>"
			}
			return result
		}
	}

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

