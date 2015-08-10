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

public class KEError : NSError
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
	
	public class func errorLocationKey() -> NSString {
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
}

