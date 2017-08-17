/**
 * @file	KSShell.swift
 * @brief	Define KSShell class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import KiwiEngine
import Canary
import JavaScriptCore
import Foundation

@objc protocol KSShellOperating: JSExport
{
	func execute(_ value: JSValue) -> JSValue
	func status(_ pid: JSValue) -> JSValue
}

public enum KSProcessStatus: Int32 {
	case Idle	= 0
	case Running	= 1
	case Succeed	= 2
	case Failed	= 3
}

@objc public class KSShell: NSObject, KSShellOperating
{
	private var mContext:		KEContext
	private var mStdout:		CNConsole
	private var mStderr:		CNConsole
	private var mProcessTable:	Dictionary<Int32, CNShell.Status>

	public init(context ctxt: KEContext){
		mContext	= ctxt
		mStdout		= CNFileConsole(file: CNTextFile.stdout)
		mStderr		= CNFileConsole(file: CNTextFile.stderr)
		mProcessTable	= [:]
	}

	public var stdout: CNConsole {
		get	 { return mStdout }
		set(cons){ mStdout = cons }
	}

	public var stderr: CNConsole {
		get	 { return mStderr }
		set(cons){ mStderr = cons }
	}

	public func execute(_ value: JSValue) -> JSValue {
		if let command = KSCommandTable.decode(value: value) {
			return execute(command: command)
		} else {
			invalidParameterError(message: "Invalid parameter for execute", value: value)
		}
		return JSValue(undefinedIn: mContext)
	}

	private func execute(command cmd: KSCommand) -> JSValue {
		let shell: CNShell
		if let cmdstr = cmd.commandLineString(){
			shell = CNShell(command: cmdstr)
		} else {
			let name = cmd.commandName
			mStderr.print(string: "Can not execute the command: \(name)")
			return JSValue(undefinedIn: mContext)
		}

		shell.outputHandler = {
			(_ string: String) -> Void in
			self.mStdout.print(string: string)
		}
		shell.errorHandler = {
			(_ string: String) -> Void in
			self.mStderr.print(string: string)
		}
		shell.terminateHandler = {
			(_ pid: Int32) -> Void in
			self.mProcessTable[pid] = shell.status
		}
		let pid = shell.execute()
		mProcessTable[pid] = .Running
		return JSValue(int32: pid, in: mContext)
	}

	public func status(_ pid: JSValue) -> JSValue {
		if pid.isNumber {
			let pval = pid.toInt32()
			if let status = mProcessTable[pval] {
				var code: Int32
				switch status {
				case .Idle:	code = KSProcessStatus.Idle.rawValue
				case .Running:	code = KSProcessStatus.Running.rawValue
				case .Finished(let c):
					if c == 0 {
						code = KSProcessStatus.Succeed.rawValue
					} else {
						code = KSProcessStatus.Failed.rawValue
					}
				}
				return JSValue(int32: code, in: mContext)
			} else {
				mStderr.print(string: "Process pid=\(pval) is not found")
				return JSValue(undefinedIn: mContext)
			}
		}
		invalidParameterError(message: "Invalid parameter for status", value: pid)
		return JSValue(undefinedIn: mContext)
	}

	private func invalidParameterError(message msg: String, value val: JSValue){
		if let text = KESerializeValue(value: val) {
			mStderr.print(string: "[Error] \(msg)\n")
			text.print(console: mStderr)
		} else {
			NSLog("Internal error: \(msg)")
		}
	}
}
