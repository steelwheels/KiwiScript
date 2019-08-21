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
	func execute(_ cmd: JSValue, _ input: JSValue, _ outout: JSValue, _ error: JSValue) -> JSValue
	func executeOnConsole(_ cmd: JSValue, _ console: JSValue) -> JSValue
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

	public func execute(_ cmd: JSValue, _ input: JSValue, _ output: JSValue, _ error: JSValue) -> JSValue {
		let inpipe 	= valueToPipe(value: input,  for: "input")
		let outpipe	= valueToPipe(value: output, for: "output")
		let errpipe	= valueToPipe(value: error,  for: "error")
		if let cmdstr = cmd.toString() {
			let shell = CNShellUtil.execute(command: cmdstr, input: inpipe, output: outpipe, error: errpipe, terminateHandler: nil)
			let process = KLProcess(process: shell, context: mContext)
			return JSValue(object: process, in: mContext)
		} else {
			return JSValue(nullIn: mContext)
		}
	}

	private func valueToPipe(value val: JSValue, for target: String) -> Pipe? {
		if val.isNull {
			return nil
		} else if let obj = val.toObject() {
			if let pipe = obj as? KLPipeObject {
				return pipe.pipe
			}
		}
		mConsole.error(string: "Invalid connection for \(target) port for Shell execution\n")
		return nil
	}

	public func executeOnConsole(_ cmd: JSValue, _ console: JSValue) -> JSValue {
		if let cmdstr = cmd.toString(), let cons = valueToConsole(value: console) {
			let shell   = CNShellUtil.execute(command: cmdstr, console: cons, terminateHandler: nil)
			let process = KLProcess(process: shell, context: mContext)
			return JSValue(object: process, in: mContext)
		} else {
			mConsole.error(string: "Invalid command \(cmd) for shell execution")
			return JSValue(nullIn: mContext)
		}
	}

	private func valueToConsole(value val: JSValue) -> CNConsole? {
		if val.isNull {
			return nil
		} else if let cons = val.toObject() as? KLConsole {
			return cons.console
		}
		mConsole.print(string: "Invalid console object \(val) for console for shell execution")
		return nil
	}

	public func searchCommand(_ cmd: JSValue) -> JSValue {
		if cmd.isString {
			if let cmdstr = cmd.toString() {
				if let retstr = CNShellUtil.searchCommand(commandName: cmdstr) {
					return JSValue(object: retstr, in: mContext)
				}
			}
		}
		return JSValue(nullIn: mContext)
	}
}

#endif // os(OSX)


