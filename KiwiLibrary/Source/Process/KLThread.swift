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
	private var mContext:	KEContext
	private var mArgument:	CNNativeValue

	public init(virtualMachine vm: JSVirtualMachine, input instrm: CNFileStream, output outstrm: CNFileStream, error errstrm: CNFileStream) {
		mContext   = KEContext(virtualMachine: vm)
		mArgument  = .nullValue
		super.init(input: instrm, output: outstrm, error: errstrm, terminationHander: {
			(_ thread: Thread) -> Int32 in
			return 0
		})
	}

	public func compile(scriptName name: String, in resource: KEResource, config conf: KEConfig) -> Bool {
		/* Compile */
		let compiler = KLCompiler()
		let config   = KEConfig(kind: .Terminal, doStrict: conf.doStrict, logLevel: conf.logLevel)
		guard compiler.compileBase(context: mContext, console: self.console, config: config) else {
			return false
		}
		guard compiler.compileResource(context: mContext, resource: resource, console: self.console, config: config) else {
			return false
		}
		/* Compile script in the package */
		guard compiler.compileScriptInResource(context: mContext, resource: resource, scriptName: name, console: self.console, config: config) else {
			return false
		}
		return true
	}

	public func compile(filePath path: String, in resource: KEResource, config conf: KEConfig) -> Bool {
		/* Compile */
		let compiler = KLCompiler()
		let config   = KEConfig(kind: .Terminal, doStrict: conf.doStrict, logLevel: conf.logLevel)
		guard compiler.compileBase(context: mContext, console: self.console, config: config) else {
			return false
		}
		guard compiler.compileResource(context: mContext, resource: resource, console: self.console, config: config) else {
			return false
		}
		/* Compile script in the given file */
		var result: Bool = false
		switch pathExtension(of: path) {
		case "js":
			let url = URL(fileURLWithPath: path, isDirectory: false)
			if let script = loadScript(from: url) {
				let _ = compiler.compile(context: mContext, statement: script, console: self.console, config: config)
				result = true
			} else {
				console.error(string: "Filed to load \(path)\n")
			}
		case "jspkg":
			let url = URL(fileURLWithPath: path, isDirectory: true)
			let res = KEResource(baseURL: url)
			result  = compile(scriptName: "main", in: res, config: conf) // Compile main
		default:
			console.error(string: "File: DEFAULT")
			//break
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

	public func start(arguments args: JSValue) {
		mArgument = args.toNativeValue()
		super.start()
	}

	public override func mainOperation() -> Int32 {
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
	private var mThread: KLThreadObject

	public init(virtualMachine vm: JSVirtualMachine, input instrm: CNFileStream, output outstrm: CNFileStream, error errstrm: CNFileStream) {
		mThread = KLThreadObject(virtualMachine: vm, input: instrm, output: outstrm, error: errstrm)
	}

	public func compile(scriptName name: String, in resource: KEResource, config conf: KEConfig) -> Bool {
		return mThread.compile(scriptName: name, in: resource, config: conf)
	}

	public func compile(filePath path: String, in resource: KEResource, config conf: KEConfig) -> Bool {
		return mThread.compile(filePath: path, in: resource, config: conf)
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

