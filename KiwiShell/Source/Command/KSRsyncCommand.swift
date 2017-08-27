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

	open override func encodeParameters() -> Dictionary<String, String>? {
		if let src = sourceDirectory, let dst = destinationDirectory {
			return ["source":src.absoluteString, "destination":dst.absoluteString]
		} else {
			return nil
		}
	}

	open override func decodeParameters(parameters params: Dictionary<String, String>) -> Bool {
		if let src = params["source"], let dst = params["destination"] {
			sourceDirectory      = URL(string: src)
			destinationDirectory = URL(string: dst)
			return (sourceDirectory != nil) && (destinationDirectory != nil)
		} else {
			return false
		}
	}
	
	open override func commandLineString() -> String? {
		if let src = sourceDirectory, let dst = destinationDirectory {
			return "/usr/bin/rsync -auvE --delete \(src.absoluteString) \(dst.absoluteString)"
		} else {
			return nil
		}
	}
}
