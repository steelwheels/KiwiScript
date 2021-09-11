/**
 * @file	KLEscapeCode.swift
 * @brief	Define KLEscapeCode class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

@objc public protocol KLEscapeCodeProtocol: JSExport
{
	func backspace() -> JSValue
	func delete() -> JSValue

	func cursorUp(_ delta: JSValue) -> JSValue
	func cursorDown(_ delta: JSValue) -> JSValue
	func cursorForward(_ delta: JSValue) -> JSValue
	func cursorBackward(_ delta: JSValue) -> JSValue
	func cursorNextLine(_ delta: JSValue) -> JSValue
	func cursorPreviousLine(_ delta: JSValue) -> JSValue
	func cursorMoveTo(_ y: JSValue, _ x: JSValue) -> JSValue

	func saveCursorPosition() -> JSValue
	func restoreCursorPosition() -> JSValue

	func eraceFromCursorToEnd() -> JSValue
	func eraceFromCursorToBegin() -> JSValue
	func eraceEntireBuffer() -> JSValue
	func eraceFromCursorToRight() -> JSValue
	func eraceFromCursorToLeft() -> JSValue
	func eraceEntireLine() -> JSValue

	func scrollUp(_ lines: JSValue) -> JSValue
	func scrollDown(_ lines: JSValue) -> JSValue

	func color(_ type: JSValue, _ color: JSValue) -> JSValue
	func bold(_ flag: JSValue) -> JSValue

	func reset() -> JSValue
}

@objc public class KLEscapeCode: NSObject, KLEscapeCodeProtocol
{
	private var mContext: KEContext

	public enum Target: Int32 {
		case	background = 0
		case	forground  = 1
	}

	public init(context ctxt: KEContext){
		mContext = ctxt
	}

	public func backspace() -> JSValue {
		return escapeCodeToValue(escapeCode: .backspace)
	}

	public func delete() -> JSValue {
		return escapeCodeToValue(escapeCode: .delete)
	}

	public func cursorUp(_ delta: JSValue) -> JSValue {
		if delta.isNumber {
			let n = Int(delta.toInt32())
			return escapeCodeToValue(escapeCode: .cursorUp(n))
		} else {
			return JSValue(nullIn: mContext)
		}
	}

	public func cursorDown(_ delta: JSValue) -> JSValue {
		if delta.isNumber {
			let n = Int(delta.toInt32())
			return escapeCodeToValue(escapeCode: .cursorDown(n))
		} else {
			return JSValue(nullIn: mContext)
		}
	}

	public func cursorForward(_ delta: JSValue) -> JSValue {
		if delta.isNumber {
			let n = Int(delta.toInt32())
			return escapeCodeToValue(escapeCode: .cursorForward(n))
		} else {
			return JSValue(nullIn: mContext)
		}
	}

	public func cursorBackward(_ delta: JSValue) -> JSValue {
		if delta.isNumber {
			let n = Int(delta.toInt32())
			return escapeCodeToValue(escapeCode: .cursorBackward(n))
		} else {
			return JSValue(nullIn: mContext)
		}
	}

	public func cursorNextLine(_ delta: JSValue) -> JSValue {
		if delta.isNumber {
			let n = Int(delta.toInt32())
			return escapeCodeToValue(escapeCode: .cursorNextLine(n))
		} else {
			return JSValue(nullIn: mContext)
		}
	}

	public func cursorPreviousLine(_ delta: JSValue) -> JSValue {
		if delta.isNumber {
			let n = Int(delta.toInt32())
			return escapeCodeToValue(escapeCode: .cursorPreviousLine(n))
		} else {
			return JSValue(nullIn: mContext)
		}
	}

	public func cursorMoveTo(_ yval: JSValue, _ xval: JSValue) -> JSValue {
		if yval.isNumber && xval.isNumber {
			let x = Int(xval.toInt32())
			let y = Int(yval.toInt32())
			return escapeCodeToValue(escapeCode: .cursorPosition(y, x))
		} else {
			return JSValue(nullIn: mContext)
		}
	}

	public func saveCursorPosition() -> JSValue {
		let code = CNEscapeCode.saveCursorPosition
		return escapeCodeToValue(escapeCode: code)
	}

	public func restoreCursorPosition() -> JSValue {
		let code = CNEscapeCode.restoreCursorPosition
		return escapeCodeToValue(escapeCode: code)
	}

	public func eraceFromCursorToEnd() -> JSValue {
		return escapeCodeToValue(escapeCode: .eraceFromCursorToEnd)
	}

	public func eraceFromCursorToBegin() -> JSValue {
		return escapeCodeToValue(escapeCode: .eraceFromCursorToBegin)
	}

	public func eraceEntireBuffer() -> JSValue {
		return escapeCodeToValue(escapeCode: .eraceEntireBuffer)
	}

	public func eraceFromCursorToRight() -> JSValue {
		return escapeCodeToValue(escapeCode: .eraceFromCursorToRight)
	}

	public func eraceFromCursorToLeft() -> JSValue {
		return escapeCodeToValue(escapeCode: .eraceFromCursorToLeft)
	}

	public func eraceEntireLine() -> JSValue {
		return escapeCodeToValue(escapeCode: .eraceEntireLine)
	}

	public func scrollUp(_ lines: JSValue) -> JSValue {
		if lines.isNumber {
			let n = Int(lines.toInt32())
			return escapeCodeToValue(escapeCode: .scrollUp(n))
		} else {
			return JSValue(nullIn: mContext)
		}
	}

	public func scrollDown(_ lines: JSValue) -> JSValue {
		if lines.isNumber {
			let n = Int(lines.toInt32())
			return escapeCodeToValue(escapeCode: .scrollDown(n))
		} else {
			return JSValue(nullIn: mContext)
		}
	}

	private func escapeCodeToValue(escapeCode code: CNEscapeCode) -> JSValue {
		let estr = code.encode()
		return JSValue(object: estr, in: mContext)
	}

	public func color(_ type: JSValue, _ color: JSValue) -> JSValue {
		var result: String? = nil
		if let targ = Target(rawValue: type.toInt32()), let col = CNColor.color(withEscapeCode: color.toInt32()) {
			switch targ {
			case .forground:
				result = CNEscapeCode.foregroundColor(col).encode()
			case .background:
				result = CNEscapeCode.backgroundColor(col).encode()
			}
		}
		if let resstr = result {
			return JSValue(object: resstr, in: mContext)
		} else {
			return JSValue(nullIn: mContext)
		}
	}

	public func bold(_ flag: JSValue) -> JSValue {
		if flag.isBoolean {
			return JSValue(bool: flag.toBool(), in: mContext)
		} else {
			return JSValue(nullIn: mContext)
		}
	}

	public func reset() -> JSValue {
		let ecode = CNEscapeCode.resetCharacterAttribute.encode()
		return JSValue(object: ecode, in: mContext)
	}
}

