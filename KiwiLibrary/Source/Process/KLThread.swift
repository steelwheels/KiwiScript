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
	var isRunning:   JSValue	{ get }
	var didFinished: JSValue	{ get }
	var exitCode:    JSValue	{ get }
	func start(_ args: JSValue)
	func terminate()
}

public enum KLSource {
	case	script(URL)			// URL of the script
	case	application(KEResource)		// application in resource
}

@objc open class KLThread: CNThread, KLThreadProtocol
{
	private var mContext:			KEContext
	private var mSourceFile:		KLSource
	private var mResource:			KEResource
	private var mChildProcessManager:	CNProcessManager
	private var mTerminalInfo:		CNTerminalInfo
	private var mConfig:			KEConfig
	private var mExceptionCount:		Int
	private var mHasEnumTable:		Bool

	public var context: KEContext { get { return mContext }}

	public init(source src: KLSource, processManager procmgr: CNProcessManager, input ifile: CNFile, output ofile: CNFile, error efile: CNFile, terminalInfo terminfo: CNTerminalInfo, environment env: CNEnvironment, config conf: KEConfig) {
		let vm			= JSVirtualMachine()
		mContext   		= KEContext(virtualMachine: vm!)
		mSourceFile		= src
		switch src {
		case .script(let url):
			mResource = KLThread.URLtoResource(packageDirectory: url, error: efile)
		case .application(let res):
			mResource = res
		}
		mChildProcessManager	= CNProcessManager()
		mTerminalInfo		= terminfo
		mConfig			= KEConfig(applicationType: conf.applicationType,
						   doStrict: conf.doStrict,
						   logLevel: conf.logLevel)
		mExceptionCount		= 0
		mHasEnumTable		= false
		super.init(processManager: procmgr, input: ifile, output: ofile, error: efile, environment: env)
		/* Add to parent manager */
		procmgr.addChildManager(childManager: mChildProcessManager)
	}

	public var isRunning: JSValue {
		get { return JSValue(bool: super.status.isRunning, in: mContext) }
	}

	public var didFinished: JSValue {
		get { return JSValue(bool: super.status.isStopped, in: mContext) }
	}

	public var exitCode: JSValue {
		return JSValue(int32: super.terminationStatus, in: mContext)
	}

	private static func URLtoResource(packageDirectory packdir: URL, error efile: CNFile) -> KEResource {
		let result: KEResource
		switch packdir.pathExtension {
		case "jspkg":
			let resource = KEResource(packageDirectory: packdir)
			let loader = KEManifestLoader()
			if let err = loader.load(into: resource) {
				let msg = "[Error] Failed to load resource from \(packdir.path): \(err.toString())\n"
				efile.put(string: msg)
			}
			result = resource
		default:
			result = KEResource(singleFileURL: packdir)
		}
		return result
	}

	public func start(_ args: JSValue) {
		let conv  = KLScriptValueToNativeValue()
		let nargs = conv.convert(scriptValue: args)
		super.start(argument: nargs)
	}

	public override func main(argument arg: CNValue) -> Int32 {
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

		/* Allocate enum table */
		mHasEnumTable = allocateEnumTable(resource: mResource)

		/* Compile */
		guard self.compile(context: mContext, resource: mResource, processManager: mChildProcessManager, terminalInfo: mTerminalInfo, environment: self.environment, console: self.console, config: mConfig) else {
			console.error(string: "Compile error\n")
			return false
		}

		/* Load main script */
		let script:  String
		let srcfile: URL?
		if let scr = mResource.loadApplication() {
			script  = scr
			srcfile = mResource.URLOfApplication()
		} else {
			let path: String
			if let p = mResource.pathStringOfApplication() {
				srcfile = URL(fileURLWithPath: p)
				path    = p
			} else {
				srcfile = URL(fileURLWithPath: #file)
				path    = #file
			}
			console.error(string: "Failed to load application sctipt: \(path)\n")
			return false
		}

		/* Convert script */
		var ext: String? = nil
		if let p = mResource.pathStringOfApplication() {
			let nsstr = p as NSString
			ext = nsstr.pathExtension
		}
		guard let newscript = convert(script: script, pathExtension: ext) else {
			console.error(string: "Failed to convert sctipt\n")
			return false
		}

		/* Execute the script */
		let runner = KECompiler()
		let _ = runner.compileStatement(context: mContext, statement: newscript, sourceFile: srcfile, console: console, config: conf)

		return true
	}

	open func compile(context ctxt: KEContext, resource res: KEResource, processManager procmgr: CNProcessManager, terminalInfo terminfo: CNTerminalInfo, environment env: CNEnvironment, console cons: CNFileConsole, config conf: KEConfig) -> Bool {
		let compiler = KLLibraryCompiler()
		return compiler.compile(context: ctxt, resource: res, processManager: procmgr, terminalInfo: terminfo, environment: env, console: cons, config: conf)
	}

	open func convert(script scr: String, pathExtension ext: String?) -> String? {
		return scr
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

	private func execOperation(argument arg: CNValue) -> Int32 {
		/* Search main function */
		var result: Int32 = -1
		if let funcval = mContext.get(name: "main") {
			/* Allocate argument */
			let conv  = KLNativeValueToScriptValue(context: mContext)
			let jsarg = conv.convert(value: arg)
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
			self.console.error(string: "main function is NOT defined\n")
		}
		/* Release enum table resource */
		if mHasEnumTable {
			releaseEnumTable()
		}
		return result
	}

	open override func terminate() {
		super.terminate()
	}

	private func allocateEnumTable(resource res: KEResource) -> Bool {
		let result: Bool
		switch CNEnumTable.loadFromResource(resource: res) {
		case .success(let etablep):
			if let etable = etablep {
				CNEnumTable.pushEnumTable(enumTable: etable)
				result = true
			} else {
				result = false
			}
		case .failure(_):
			result = false	// No enum definition in resource file
		}
		return result
	}

	private func releaseEnumTable() {
		CNEnumTable.popEnumTable()
	}
}
