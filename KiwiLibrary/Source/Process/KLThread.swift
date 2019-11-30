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

private class KLThreadObject: CNThread
{
	public typealias ScriptFile = KLThread.ScriptFile

	private var mContext:		KEContext
	private var mScriptFile:	ScriptFile
	private var mResource:		KEResource
	private var mConfig:		KEConfig
	private var mArgument:		CNNativeValue

	public init(virtualMachine vm: JSVirtualMachine, scriptFile file: ScriptFile, input instrm: CNFileStream, output outstrm: CNFileStream, error errstrm: CNFileStream, resource res: KEResource, config conf: KEConfig) {
		mContext   	= KEContext(virtualMachine: vm)
		mScriptFile	= file
		mResource	= res
		mConfig		= conf
		mArgument  	= .nullValue
		super.init(input: instrm, output: outstrm, error: errstrm, terminationHander: {
			(_ thread: Thread) -> Int32 in
			return 0
		})
	}

	public func start(arguments args: JSValue) {
		mArgument = args.toNativeValue()
		super.start()
	}

	public override func mainOperation() -> Int32 {
		if compile() {
			return execOperation()
		} else {
			return -1
		}
	}

	private func compile() -> Bool {
		/* Compile */
		let compiler = KLCompiler()
		let config   = KEConfig(kind: .Terminal, doStrict: mConfig.doStrict, logLevel: mConfig.logLevel)
		guard compiler.compileBase(context: mContext, console: self.console, config: config) else {
			return false
		}
		guard compiler.compileLibraryInResource(context: mContext, resource: mResource, console: self.console, config: config) else {
			return false
		}
		/* Load script */
		let script: String?
		switch mScriptFile {
		case .identifier(let ident):
			script = mResource.loadScript(identifier: ident, index: 0)
		case .url(let url):
			script = loadScript(from: url)
		case .unselected:
			if let url = selectInputFile() {
				script = loadMainScript(from: url)
			} else {
				console.error(string: "Failed to select script")
				return false
			}
		}
		if let scr = script {
			let _ = compiler.compile(context: mContext, statement: scr, console: console, config: mConfig)
		} else {
			console.error(string: "Failed to load script: \(mScriptFile.description())")
			return false
		}
		return true
	}

	private func selectInputFile() -> URL? {
		return nil
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

	private func execOperation() -> Int32 {
		/* Search main function */
		var result: Int32 = 0
		if let funcval = mContext.getValue(name: "main") {
			/* Allocate argument */
			let arg = mArgument.toJSValue(context: mContext)
			/* Call main function */
			if let retval = funcval.call(withArguments: [arg]) {
				result = retval.toInt32()
			} else {
				self.console.error(string: "Failed to call main function")
				result = 1
			}
		} else {
			self.console.error(string: "main function is NOT found.")
			result = 1
		}
		return result
	}
}

@objc public class KLThread: NSObject, KLThreadProtocol
{
	public enum ScriptFile {
		case identifier(String)		// script indentifier in package file
		case url(URL)			// URL of external file
		case unselected			// Not selected yet

		func description() -> String {
			let result: String
			switch self {
			case .identifier(let ident):
				result = ident
			case .url(let url):
				result = url.path
			case .unselected:
				result = "<not defined>"
			}
			return result
		}
	}

	private var mThread: KLThreadObject

	public init(virtualMachine vm: JSVirtualMachine, scriptFile file: ScriptFile, input instrm: CNFileStream, output outstrm: CNFileStream, error errstrm: CNFileStream, resource res: KEResource, config conf: KEConfig) {
		mThread = KLThreadObject(virtualMachine: vm, scriptFile: file, input: instrm, output: outstrm, error: errstrm, resource: res, config: conf)
	}

	public func start(_ args: JSValue) {
		mThread.start(arguments: args)
	}

	public func isRunning() -> Bool {
		let result: Bool
		switch mThread.status {
		case .Finished:		result = false
		case .Idle:		result = false
		case .Running:		result = true
		}
		return result
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

