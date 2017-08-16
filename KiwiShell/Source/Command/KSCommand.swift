/**
 * @file	KSCommand.swift
 * @brief	Define KSCommand class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation

open class KSCommand
{
	private var mCommandName: String

	public var commandName: String { get { return mCommandName }}

	public init(name nm: String){
		mCommandName	= nm
	}

	open func encodeParameters() -> Dictionary<String, String> {
		let result: Dictionary<String, String> = [:]
		return result
	}

	open func commandLineString() -> String {
		fatalError("Must be override")
	}
}

