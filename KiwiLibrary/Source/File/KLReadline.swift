/**
 * @file	KLReadline.swift
 * @brief	Define KLReadline class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import CoconutData
import KiwiEngine
import JavaScriptCore
import Foundation

@objc public protocol KLReadlineProtocol: JSExport {
	//func input()	-> JSValue
	func history()	-> JSValue
}

@objc public class KLReadline: NSObject, KLReadlineProtocol
{
	private var mReadline:		CNReadline
	private var mContext:		KEContext

	public init(readline rline: CNReadline, context ctxt: KEContext) {
		mReadline	= rline
		mContext	= ctxt
	}

	public func history() -> JSValue {
		return JSValue(object: mReadline.history, in: mContext)
	}
}

/*
@objc public class KLReadline: NSObject, KLReadlineProtocol
{
	private struct ReadlineStatus {
		var	editingLine	: String
		var 	editingPosition	: Int

		public init(){
			editingLine	= ""
			editingPosition	= 0
		}
	}

	private var	mContext:		KEContext
	private var	mEnvironment:		CNEnvironment
	private var	mTerminalInfo:		CNTerminalInfo
	private var	mConsole:		CNFileConsole
	private var	mHistory:		CNCommandHistory
	private var 	mReadline:		CNReadline
	private var 	mReadlineStatus:	ReadlineStatus

	public init(context ctxt: KEContext, terminalInfo terminfo: CNTerminalInfo, environment env: CNEnvironment, console cons: CNFileConsole) {
		mContext	= ctxt
		mTerminalInfo	= terminfo
		mEnvironment	= env
		mConsole	= cons
		mHistory	= CNCommandHistory()
		mReadline 	= CNReadline(commandHistory: mHistory)
		mReadlineStatus	= ReadlineStatus()
	}

	public func input() -> JSValue {
		guard var result = JSValue(nullIn: mContext) else {
			fatalError("Failed to allocate object")
		}
		var docont = true
		while docont {
			switch mReadline.readLine(console: mConsole) {
			case .string(let str, let idx, let determined):
				if determined {
					/* Return command line */
					result = determineCommandLine(newLine: str)
					docont = false
				} else {
					updateCommandLine(newLine: str, newPosition: idx)
				}
			case .none:
				break /* do continue loop */
			case .error(let err):
				NSLog("[Error] \(err.description()) at \(#function)")
			@unknown default:
				NSLog("Can not happen at \(#function)")
				docont = false
			}
		}
		return result
	}

	private func determineCommandLine(newLine newline: String) -> JSValue {
		/* Replace replay command */
		/*
		let newcmd = mReadline.replaceReplayCommand(source: newline)
*/

		/* Save current command */
		/*
		mReadline.addCommand(command: newcmd)
*/

		/* Reset terminal after newline */
		let resetstr = CNEscapeCode.resetCharacterAttribute.encode()
		mConsole.print(string: "\n" + resetstr)

		/* Print prompt again */
		mReadlineStatus.editingLine     = ""
		mReadlineStatus.editingPosition	= 0

		return JSValue(object: newline, in: mContext)
	}

	private func updateCommandLine(newLine newline: String, newPosition newpos: Int) {
		let BS  = CNEscapeCode.backspace.encode()
		let DEL = BS + " " + BS

		/* Move cursor to end of line */
		let forward = mReadlineStatus.editingLine.count - mReadlineStatus.editingPosition
		if forward > 0 {
			let fwdstr  = CNEscapeCode.cursorForward(forward).encode()
			mConsole.print(string: fwdstr)
		}

		/* Erace current command line */
		let curlen  = mReadlineStatus.editingLine.count
		for _ in 0..<curlen {
			mConsole.print(string: DEL)
		}
		/* Print new command line */
		mConsole.print(string: newline)

		/* Adjust cursor */
		let newlen = newline.count
		let back   = newlen - newpos
		let bakstr = CNEscapeCode.cursorBackward(back).encode()
		if back > 0 {
			mConsole.print(string: bakstr)
		}

		/* Update current line*/
		mReadlineStatus.editingLine     = newline
		mReadlineStatus.editingPosition = newpos
	}
}
*/

