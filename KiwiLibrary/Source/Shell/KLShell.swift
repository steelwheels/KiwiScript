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

	public init(context ctxt: KEContext){
		mContext = ctxt
	}

	public func execute(_ cmd: JSValue, _ input: JSValue, _ output: JSValue, _ error: JSValue) -> JSValue {
		let inpipe 	= valueToPipe(value: input)
		let outpipe	= valueToPipe(value: output)
		let errpipe	= valueToPipe(value: error)
		if let cmdstr = cmd.toString() {
			let shell = CNShell.execute(command: cmdstr, input: inpipe, output: outpipe, error: errpipe, terminateHandler: nil)
			let process = KLProcess(process: shell, context: mContext)
			return JSValue(object: process, in: mContext)
		} else {
			return JSValue(nullIn: mContext)
		}
	}

	private func valueToPipe(value val: JSValue) -> Pipe? {
		if val.isNull {
			return nil
		} else if let obj = val.toObject() {
			if let pipe = obj as? KLPipeObject {
				return pipe.pipe.pipe
			}
		}
		CNLog(type: .Error, message: "Invalid object: \(val)", place: #file)
		return nil
	}

	public func executeOnConsole(_ cmd: JSValue, _ console: JSValue) -> JSValue {
		if let cmdstr = cmd.toString(), let cons = valueToConsole(value: console) {
			let shell   = CNShell.execute(command: cmdstr, console: cons, terminateHandler: nil)
			let process = KLProcess(process: shell, context: mContext)
			return JSValue(object: process, in: mContext)
		} else {
			CNLog(type: .Error, message: "Invalid object: \(cmd) or \(console)", place: #file)
			return JSValue(nullIn: mContext)
		}
	}

	private func valueToConsole(value val: JSValue) -> CNConsole? {
		if val.isNull {
			return nil
		} else if let cons = val.toObject() as? KLConsole {
			return cons.console
		}
		CNLog(type: .Error, message: "Invalid object: \(val)", place: #file)
		return nil
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


