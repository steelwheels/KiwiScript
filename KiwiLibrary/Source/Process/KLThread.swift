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
}

public class KLThreadObject: CNThread
{
	public typealias ScriptFile = KLThread.ScriptFile

	private var mContext:		KEContext
	private var mScriptFile:	ScriptFile
	private var mResource:		KEResource
	private var mConfig:		KEConfig

	public init(virtualMachine vm: JSVirtualMachine, scriptFile file: ScriptFile, queue disque: DispatchQueue,input instrm: CNFileStream, output outstrm: CNFileStream, error errstrm: CNFileStream, resource res: KEResource, config conf: KEConfig) {
		mContext   	= KEContext(virtualMachine: vm)
		mScriptFile	= file
		mResource	= res
		mConfig		= KEConfig(applicationType: conf.applicationType,
						  doStrict: conf.doStrict,
						  logLevel: conf.logLevel)
		super.init(queue: disque, input: instrm, output: outstrm, error: errstrm)
	}

	public override func main(arguments args: Array<CNNativeValue>) -> Int32 {
		if compile(config: mConfig) {
			return execOperation(arguments: args)
		} else {
			return -1
		}
	}

	private func compile(config conf: KEConfig) -> Bool {
		/* Compile */
		let compiler = KLCompiler()
		guard compiler.compileBase(context: mContext, console: self.console, config: conf) else {
			return false
		}
		guard compiler.compileLibraryInResource(context: mContext, queue: self.queue, resource: mResource, console: self.console, config: conf) else {
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

	public init(virtualMachine vm: JSVirtualMachine, scriptFile file: ScriptFile, queue disque: DispatchQueue, input instrm: CNFileStream, output outstrm: CNFileStream, error errstrm: CNFileStream, resource res: KEResource, config conf: KEConfig) {
		mThread = KLThreadObject(virtualMachine: vm, scriptFile: file, queue: disque, input: instrm, output: outstrm, error: errstrm, resource: res, config: conf)
	}

	public func start(_ args: JSValue) {
		let nval = args.toNativeValue()
		let nargs: Array<CNNativeValue>
		if let narr = nval.toArray() {
			nargs = narr
		} else {
			nargs = [nval]
		}
		mThread.start(arguments: nargs)
	}

	public func isRunning() -> Bool {
		return mThread.isRunning
	}

	public func waitUntilExit() -> Int32 {
		return mThread.waitUntilExit()
	}

	public func print(string str: String) {
		mThread.outputFileHandle.write(string: str)
	}

	public func error(string str: String) {
		mThread.errorFileHandle.write(string: str)
	}
}

