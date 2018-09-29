/*
 * @file	KLShell.swift
 * @brief	Define KLShell class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

#if os(OSX)

import CoconutData
import CoconutShell
import KiwiEngine
import JavaScriptCore
import Foundation

@objc public protocol KLShellProtocol: JSExport
{
	func execute(_ cmd: JSValue) -> JSValue
	func searchCommand(_ cmd: JSValue) -> JSValue
}

@objc public class KLShell: NSObject, KLShellProtocol
{
	private var mContext:	KEContext
	private var mConsole:	CNConsole

	public init(context ctxt: KEContext, console cons: CNConsole){
		mContext = ctxt
		mConsole = cons
	}

	public func execute(_ cmd: JSValue) -> JSValue {
		if let cmdstr = cmd.toString()  {
			let shell = CNShell.execute(command: cmdstr, console: mConsole, terminateHandler: nil)
			let process = KLProcess(process: shell, context: mContext)
			return JSValue(object: process, in: mContext)
		} else {
			return JSValue(nullIn: mContext)
		}
	}

	public func searchCommand(_ cmd: JSValue) -> JSValue {
		if cmd.isString {
			if let cmdstr = cmd.toString() {
				if let retstr = CNShell.searchCommand(commandName: cmdstr) {
					return JSValue(object: retstr, in: mContext)
				}
			}
		}
		return JSValue(nullIn: mContext)
	}
}

#endif // os(OSX)


