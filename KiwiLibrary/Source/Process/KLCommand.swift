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
	public typealias EvalFunc = (_ arg: JSValue, _ env: CNEnvironment) -> Int32

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
		mTerminationStatus = mFunction(arg, mEnvironment)
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
			(_ arg: JSValue, _ env: CNEnvironment) -> Int32 in
			return KLCdCommand.execute(arg, cons, env)
		}, context: ctxt, console: cons, environment: env)
	}

	private static func execute(_ arg: JSValue, _ console: CNConsole, _ env: CNEnvironment) -> Int32 {
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
					console.error(string: "Error: not directory")
				}
			} else {
				console.error(string: "Error: Failed to convert to string")
			}
		} else if arg.isNull {
			let home = CNPreference.shared.userPreference.homeDirectory
			env.currentDirectory = home
			result = 0
		} else {
			console.error(string: "Error: Invalid parameter for path")
		}
		return result
	}
}

@objc open class KLSetupCommand: KLCommand
{
	public init(context ctxt: KEContext, console cons: CNConsole, environment env: CNEnvironment) {
		super.init(function: {
			(_ arg: JSValue, _ env: CNEnvironment) -> Int32 in
			return KLSetupCommand.execute(arg, cons, env)
		}, context: ctxt, console: cons, environment: env)
	}

	private static func execute(_ arg: JSValue, _ console: CNConsole, _ env: CNEnvironment) -> Int32 {
		let result: Int32
		let fmanager 		= FileManager.default
		if let err = fmanager.setupFileSystem(console: console) {
			console.error(string: "setup: [Error] \(err.toString())\n")
			result = 1 ;
		} else {
			/* No error */
			result = 0
		}
		return result
	}
}
