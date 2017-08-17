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

	public class func callerScript(command name: String, parameters params: Dictionary<String, String>) -> String {
		let header =   "var \(name)Command = {\n"
			     + "  command: \"\(name)\",\n"
			     + "  parameters: {\n"
		let footer =   "  }\n"
			     + "};\n"
		var body:  String = ""
		var is1st: Bool = false
		for key in params.keys {
			if is1st {
				is1st = false
			} else {
				body  = body + ",\n"
			}
			if let value = params[key] {
				body = body + "   \(key) : \"\(value)\""
			} else {
				NSLog("Internal error")
			}
		}
		return header + footer
	}

	open func encodeParameters() -> Dictionary<String, String> {
		fatalError("Must be override")
	}

	open func decodeParameters(parameters params: Dictionary<String, String>) -> Bool {
		fatalError("Must be override")
	}

	open func commandLineString() -> String? {
		fatalError("Must be override")
	}
}

