/**
 * @file	KSCommandTable.swift
 * @brief	Define KSCommandTable class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import KiwiEngine
import JavaScriptCore
import Foundation

public class KSCommandTable
{
	public class func encode(command cmd: KSCommand, context ctxt: KEContext) -> JSValue
	{
		let dict = NSMutableDictionary(capacity: 8)
		let params = cmd.encodeParameters()
		for key in params.keys {
			if let val = params[key] {
				dict.setValue(val, forKey: key)
			} else {
				NSLog("Can not happen")
			}
		}
		let result = NSMutableDictionary(capacity: 4)
		result.setValue(NSString(string: cmd.commandName), forKey: "command")
		result.setValue(dict, forKey: "parameters")
		return JSValue(object: result, in: ctxt)
	}

	public class func decode(value val: JSValue) -> KSCommand?
	{
		if !val.isObject {
			return nil
		}
		if let dict = val.toObject() as? NSMutableDictionary {
			if let nstr  = dict.value(forKey: "command")    as? NSString,
				let pdict = dict.value(forKey: "parameters") as? NSDictionary {
				return KSCommandTable.decode(name: nstr as String, parameters: pdict)
			}
		}
		return nil
	}

	private class func decode(name nm:String, parameters params: NSDictionary) -> KSCommand?
	{
		var result: KSCommand?
		switch nm {
		case "ls":
			result = KSLsCommand()
		default:
			NSLog("Unknown command name: \(nm)")
			result = nil
		}
		return result
	}
}
