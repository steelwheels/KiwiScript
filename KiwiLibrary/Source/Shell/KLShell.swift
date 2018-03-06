/*
 * @file	KLShell.swift
 * @brief	Define KLShell class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import Canary
import KiwiEngine
import JavaScriptCore
import Foundation

@objc public protocol KLShellProtocol: JSExport
{
	func execute(_ cmd: JSValue, _ infile: JSValue, _ outfile: JSValue, _ errfile: JSValue) -> JSValue
	func searchCommand(_ cmd: JSValue) -> JSValue
}

@objc public class KLShell: NSObject, KLShellProtocol
{
	private var mContext:	KEContext

	public init(context ctxt: KEContext){
		mContext = ctxt
	}

	public func execute(_ cmd: JSValue, _ infile: JSValue, _ outfile: JSValue, _ errfile: JSValue) -> JSValue {
		let inport  = castToPort(value: infile)
		let outport = castToPort(value: outfile)
		let errport = castToPort(value: errfile)
		if let cmdstr = cmd.toString(), let inport = inport, let outport = outport, let errport = errport {
			let shell = CNShell.execute(command: cmdstr, inputFile: inport, outputFile: outport, errorFile: errport, terminateHandler: nil)
			let process = KLProcessObject(process: shell, context: mContext)
			return JSValue(object: process, in: mContext)
		} else {
			return JSValue(nullIn: mContext)
		}
	}

	private func castToPort(value val: JSValue) -> CNShell.Port? {
		let result: CNShell.Port?
		if val.isObject {
			if let file:KLFileObject = JSValue.castObject(value: val) {
				result = .File(file.file)
			} else if let pipe:KLPipeObject = JSValue.castObject(value: val) {
				result = .Pipe(pipe.pipe)
			} else {
				/* Invalid object */
				result = nil
			}
		} else if val.isNull {
			result = .Standard
		} else {
			/* Invalid parameter */
			result = nil
		}
		return result
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


