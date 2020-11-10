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
	public typealias EvalFunc = (_ args: Array<JSValue>, _ env: CNEnvironment) -> Int32

	private var mContext:			KEContext
	private var mFunction: 			EvalFunc
	private var mEnvironment:		CNEnvironment
	private var mTerminationStatus:		Int32

	public init(function efunc: @escaping EvalFunc, context ctxt: KEContext, environment env: CNEnvironment) {
		mFunction 		= efunc
		mContext		= ctxt
		mEnvironment		= env
		mTerminationStatus	= -1
	}

	public func start(_ args: JSValue) {
		/* get arguments */
		let params = divideArgs(args)
		/* Call function */
		mTerminationStatus = mFunction(params, mEnvironment)
	}

	private func divideArgs(_ args: JSValue) -> Array<JSValue> {
		if args.isArray {
			if let arr = args.toArray() {
				var result: Array<JSValue> = []
				for elm in arr {
					if let val = elm as? JSValue {
						result.append(val)
					} else {
						if let newval = JSValue(object: elm, in: mContext) {
							result.append(newval)
						} else {
							NSLog("Failed to allocate value")
						}
					}
				}
				return result
			}
		}
		return [args]
	}

	public func isRunning() -> Bool {
		return false
	}

	public func waitUntilExit() -> Int32 {
		return mTerminationStatus
	}

	public func terminate() {
		/* ignore */
	}

}

@objc open class KLCdCommand: KLCommand
{
	public init(context ctxt: KEContext, environment env: CNEnvironment) {
		super.init(function: {
			(_ args: Array<JSValue>, _ env: CNEnvironment) -> Int32 in
			return KLCdCommand.execute(args, env)
		}, context: ctxt, environment: env)
	}

	private static func execute(_ args: Array<JSValue>, _ env: CNEnvironment) -> Int32 {
		var result: Int32 = -1
		switch args.count {
		case 0:
			/* Change to current directory */
			let home = CNPreference.shared.userPreference.homeDirectory
			env.currentDirectory = home
			result = 0
		case 1:
			let fmanager = FileManager.default
			if args[0].isString {
				if let path = args[0].toString() {
					let basedir = env.currentDirectory
					let newpath = fmanager.fullPath(pathString: path, baseURL: basedir)
					switch fmanager.checkFileType(pathString: newpath.path) {
					case .Directory:
						env.currentDirectory = newpath
						result = 0 // No error
					default:
						break
					}
				}
			}
			break
		default:
			break
		}
		return result
	}
}
