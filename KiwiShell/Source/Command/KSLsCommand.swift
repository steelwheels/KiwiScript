/*
 * @file	KSLsCommand.swift
 * @brief	Define KSLsCommand class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation

public class KSLsCommand: KSCommand
{
	public init(){
		super.init(name: "ls")
	}

	public class func callerScript() -> String {
		return KSCommand.callerScript(command: "ls", parameters: [:])
	}

	open override func commandLineString() -> String {
		return "/bin/ls"
	}
}

