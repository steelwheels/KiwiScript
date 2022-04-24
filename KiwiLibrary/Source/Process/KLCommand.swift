/**
 * @file	KLCommand.swift
 * @brief	Define KLCommand class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation

@objc open class KLCommand: NSObject, KLThreadProtocol
{
	public typealias EvalFunc = (_ arg: JSValue, _ ctxt: KEContext, _ env: CNEnvironment) -> Int32

	private var mContext:			KEContext
	private var mFunction: 			EvalFunc
	private var mConsole:			CNConsole
	private var mEnvironment:		CNEnvironment
	private var mTerminationStatus:		Int32

	public var console: CNConsole { get { return mConsole }}

	public init(function efunc: @escaping EvalFunc, context ctxt: KEContext, console cons: CNConsole, environment env: CNEnvironment) {
		mFunction 		= efunc
		mContext		= ctxt
		mConsole		= cons
		mEnvironment		= env
		mTerminationStatus	= -1
	}

	public func start(_ arg: JSValue) {
		/* Call function */
		mTerminationStatus = mFunction(arg, mContext, mEnvironment)
	}

	public var isRunning: JSValue {
		return JSValue(bool: false, in: mContext)
	}

	public var didFinished: JSValue {
		return JSValue(bool: true, in: mContext)
	}

	public var exitCode: JSValue {
		return JSValue(int32: mTerminationStatus, in: mContext)
	}

	public func terminate() {
		/* ignore */
	}

}

@objc open class KLCdCommand: KLCommand
{
	public init(context ctxt: KEContext, console cons: CNConsole, environment env: CNEnvironment) {
		super.init(function: {
			(_ arg: JSValue, _ ctxt: KEContext, _ env: CNEnvironment) -> Int32 in
			return KLCdCommand.execute(arg, ctxt, cons, env)
		}, context: ctxt, console: cons, environment: env)
	}

	private static func execute(_ arg: JSValue, _ context: KEContext, _ console: CNConsole, _ env: CNEnvironment) -> Int32 {
		var result: Int32	= -1

		let fmanager 		= FileManager.default
		if arg.isString {
			if let path = arg.toString() {
				let basedir = env.currentDirectory
				let newpath = fmanager.fullPath(pathString: path, baseURL: basedir)
				switch fmanager.checkFileType(pathString: newpath.path) {
				case .Directory:
					env.currentDirectory = newpath
					result = 0 // No error
				default:
					console.error(string: "Error: not directory\n")
				}
			} else {
				console.error(string: "Error: Failed to convert to string\n")
			}
		} else if arg.isNull {
			let home = CNPreference.shared.userPreference.homeDirectory
			env.currentDirectory = home
			result = 0
		} else {
			console.error(string: "Error: Invalid parameter for path\n")
		}
		return result
	}
}

@objc open class KLCleanCommand: KLCommand
{
	static public let builtinFunctionName = "clean"

	public init(context ctxt: KEContext, console cons: CNConsole, environment env: CNEnvironment) {
		super.init(function: {
			(_ arg: JSValue, _ ctxt: KEContext, _ env: CNEnvironment) -> Int32 in
			return KLCleanCommand.execute(arg, ctxt, cons, env)
		}, context: ctxt, console: cons, environment: env)
	}

	private static func execute(_ arg: JSValue, _ context: KEContext, _ console: CNConsole, _ env: CNEnvironment) -> Int32 {
		/* get target script name */
		let scrname: String
		if arg.isString{
			scrname = arg.toString()
		} else if arg.isNull {
			#if os(OSX)
				let semaphore = DispatchSemaphore(value: 0)
				var name: String? = nil
				URL.openPanel(title: "Select script for clean", type: .File, extensions: ["jspkg"], callback: {
					(_ url: URL?) -> Void in
					if let u = url { name = u.lastPathComponent }
					semaphore.signal()
				})
				semaphore.wait()
				if let n = name {
					scrname = n
				} else {
					console.error(string: "Error: The target script name is required\n")
					return -1 // No argument
				}
			#else
				console.error(string: "Error: The target script name is required\n")
				return -1 // No argument
			#endif
		} else {
			console.error(string: "Error: The target script name is required\n")
			return -1
		}

		var result: Int32 = -1
		let fmanager = FileManager.default
		let targurl  = CNFilePath.URLforApplicationSupportDirectory(subDirectory: scrname)
		if fmanager.fileExists(atURL: targurl) {
			if fmanager.isDeletableFile(atURL: targurl) {
				switch fmanager.removeFile(atURL: targurl) {
				case .ok:
					result = 0	// done
				case .error(let err):
					console.error(string: "Error: \(err.toString())\n")
				@unknown default:
					console.error(string: "Error: Unexpected result\n")
				}
				result = 0
			} else {
				console.error(string: "The file is not deletable: \(targurl.path)\n")
			}
		}
		return result
	}
}

@objc open class KLInstallCommand: KLCommand
{
	static public let builtinFunctionName = "_install"

	public init(context ctxt: KEContext, console cons: CNConsole, environment env: CNEnvironment) {
		super.init(function: {
			(_ arg: JSValue, _ ctxt: KEContext, _ env: CNEnvironment) -> Int32 in
			return KLInstallCommand.execute(arg, ctxt, cons, env)
		}, context: ctxt, console: cons, environment: env)
	}

	private static func execute(_ arg: JSValue, _ context: KEContext, _ console: CNConsole, _ env: CNEnvironment) -> Int32 {
		let result: Int32

		let dstdir = CNPreference.shared.userPreference.homeDirectory

		let installer = CNResourceInstaller(console: console)
		if installer.install(destinationDirectory: dstdir, sourceDirectoryNames: ["Library", "Game", "Sample", "Utility"]) {
			result = 0
		} else {
			result = 1
		}
		return result
	}
}
