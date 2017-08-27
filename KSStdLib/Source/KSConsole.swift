/**
 * @file	KSConsole.swift
 * @brief	Define KSConsole library class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Canary
import Foundation
import JavaScriptCore


@objc protocol KSConsoleOperating : JSExport {
	func put(_ value: JSValue)
	func fput(_ fd: JSValue, _ value: JSValue)
}

@objc public class KSConsole : NSObject, KSConsoleOperating
{
	private static let mStdInFd	: Int32 = 0
	private static let mStdOutFd	: Int32 = 1
	private static let mStdErrFd	: Int32 = 2

	private var mStdOut : CNConsole
	private var mStdErr : CNConsole

	public init(stdout outcons: CNConsole, stderr errcons: CNConsole){
		mStdOut = outcons
		mStdErr = errcons
		super.init()
	}
	
	public class func rootObjectName() -> NSString {
		return "console"
	}
	
	public func registerToContext(context ctxt: JSContext){
		ctxt.setObject(self, forKeyedSubscript: KSConsole.rootObjectName())
	}

	public class func preCompileScript() -> String
	{
		let script =	  "stdin  = \(KSConsole.mStdInFd) ;\n"
				+ "stdout = \(KSConsole.mStdOutFd) ;\n"
				+ "stderr = \(KSConsole.mStdErrFd) ;\n"
		return script
	}

	public func put(_ val: JSValue){
		mStdOut.print(string: val.description + "\n")
	}

	public func fput(_ fd: JSValue, _ val: JSValue){
		if fd.isNumber {
			switch fd.toInt32() {
			case KSConsole.mStdOutFd: mStdOut.print(string: val.description)
			case KSConsole.mStdErrFd: mStdErr.print(string: val.description)
			default:
				let msg = "[Error] KSConsole: invalid fd: \(fd.description)\n"
					+ val.description
				mStdErr.print(string: msg)
			}
		} else {
			NSLog("Invalid fd: \(fd.description)")
		}
	}
}
