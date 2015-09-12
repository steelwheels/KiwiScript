/**
 * @file	KLOutputStream.swift
 * @brief	Extend KLConsole class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Cocoa
import JavaScriptCore

public class KSOutputStream: NSObject
{	
	public func putErrors(errors: Array<NSError>){
		var message : String = ""
		for error : NSError in errors {
			message += error.toString() + "\n"
		}
		puts(message)
	}
	
	public func put(val : JSValue){
		putString(val.description)
	}
	
	public func putString(str : String){
		NSLog(str)
	}
}
