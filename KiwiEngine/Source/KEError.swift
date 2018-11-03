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
	case SyntaxError(String)	// Error message
	}

	private var mContext: ErrorType

	public init(syntaxError message: String){
		mContext = .SyntaxError(message)
	}
}

