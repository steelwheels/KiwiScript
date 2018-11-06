/**
 * @file	KEError.swift
 * @brief	Define KEError class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import Foundation

public class KEError: Error
{
	public enum ErrorType {
	case CanNotReadError(String)	// File-name
	case InternalError(String)	// Error-message
	case ParseError(String)		// Error-message
	}

	private var mContext: ErrorType

	public init(parseError message: String){
		mContext = .ParseError(message)
	}

	public init(internalError message: String){
		mContext = .InternalError(message)
	}

	public init(canNotReadError filename: String){
		mContext = .CanNotReadError(filename)
	}

	public var description: String {
		get {
			var result: String
			switch mContext {
			case .InternalError(let message):
				result = "[InternalError] " + message
			case .ParseError(let message):
				result = "[ParseError] " + message
			case .CanNotReadError(let filename):
				result = "[FileError] Can not read \"\(filename)\""
			}
			return result
		}
	}

	public func toNSError() -> NSError {
		let result: NSError
		switch mContext {
		case .CanNotReadError(let filename):
			result = NSError.fileError(message: "Can not read \"\(filename)\"")
		case .InternalError(let message):
			result = NSError.internalError(message: message)
		case .ParseError(let message):
			result = NSError.parseError(message: message)
		}
		return result
	}
}

