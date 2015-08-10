/**
* @file		KEError.swift
* @brief	Extend KEError class
* @par Copyright
*   Copyright (C) 2015 Steel Wheels Project
*/

import Foundation

public enum KEErrorCode {
	case ParseError
}

public extension NSError
{
	public class func domain() -> String {
		return "github.com.steelwheels.KiwiEngine"
	}
	
	public class func codeToValue(code : KEErrorCode) -> Int {
		var value : Int = 0
		switch(code){
		case .ParseError:
			value = 1 ;
		}
		return value
	}
	
	public class func errorLocationKey() -> String {
		return "errorLocation"
	}
	
	public class func parseError(message : NSString) -> NSError {
		let userinfo = [NSLocalizedDescriptionKey: message]
		let error = NSError(domain: self.domain(), code: codeToValue(KEErrorCode.ParseError), userInfo: userinfo)
		return error
	}
	
	public class func parseError(message : NSString, location : NSString) -> NSError {
		let userinfo = [NSLocalizedDescriptionKey: message, self.errorLocationKey(): location]
		let error = NSError(domain: self.domain(), code: codeToValue(KEErrorCode.ParseError), userInfo: userinfo)
		return error
	}
	
	public func toString() -> String {
		var message = "[Error] "
		if let dict : Dictionary = userInfo {
			if let desc = dict[NSLocalizedDescriptionKey] as? String {
				message = message + desc
			} else {
				message = message + "Unknown error "
			}
			let lockey : String = NSError.errorLocationKey()
			if let location = dict[lockey] as? String {
				message = message + "in " + location
			}
			return message
		} else {
			return message + "Unknown error"
		}
	}
}


