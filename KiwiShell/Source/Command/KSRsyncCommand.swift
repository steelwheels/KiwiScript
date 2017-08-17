/*
 * @file	KSRsyncCommand.swift
 * @brief	Define KSRsyncCommand class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation

public class KSRsyncCommand: KSCommand
{
	private var	sourceDirectory:	URL?
	private var	destinationDirectory:	URL?

	public init(){
		sourceDirectory      = nil
		destinationDirectory = nil
		super.init(name: "rsync")
	}

	public class func callerScript() -> String? {
		return KSCommand.callerScript(command: "rsync", parameters: [:])
	}

	open override func encodeParameters() -> Dictionary<String, String> {
		hoge
	}

	open override func decodeParameters(parameters params: Dictionary<String, String>) -> Bool {
		return true
	}
	
	open override func commandLineString() -> String? {
		return "/usr/bin/rsync"
	}
}
