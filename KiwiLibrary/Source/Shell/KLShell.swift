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
		let inobj  = castToFileObject(value: infile,  defaultFile: CNStandardFile(type: .input),  context: mContext)
		let outobj = castToFileObject(value: outfile, defaultFile: CNStandardFile(type: .output), context: mContext)
		let errobj = castToFileObject(value: errfile, defaultFile: CNStandardFile(type: .error),  context: mContext)
		if let cmdstr = cmd.toString(), let infileobj  = inobj, let outfileobj = outobj, let errfileobj = errobj {
			let shell = CNShell.execute(command: cmdstr, inputFile: infileobj.coreObject, outputFile: outfileobj.coreObject, errorFile: errfileobj.coreObject, terminateHandler: nil)
			let process = KLProcessObject(process: shell, context: mContext)
			return JSValue(object: process, in: mContext)
		} else {
			return JSValue(nullIn: mContext)
		}
	}

	private func castToFileObject(value val: JSValue, defaultFile deffile: CNTextFile, context ctxt: KEContext) -> KLFileObject? {
		let result: KLFileObject?
		if val.isObject {
			result = JSValue.castObject(value: val)
		} else if val.isNull {
			result = KLFileObject(file: deffile, context: ctxt)
		} else {
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


