/**
* @file	KLOutputStream.swift
* @brief	Extend KLConsole class
* @par Copyright
*   Copyright (C) 2015 Steel Wheels Project
*/

import Cocoa
import JavaScriptCore

@objc protocol KLOutputStreamProtocol : JSExport
{
	func put(val : JSValue) ;
}

public class KLOutputStream: NSObject
{
	public func put(val : JSValue){
		putString(val.description)
	}
	
	internal func putString(str : String){
		NSLog(str)
	}
}
