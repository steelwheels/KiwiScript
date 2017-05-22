/**
 * @file	KSDebug.swift
 * @brief	Define KSDebug library class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Canary
import JavaScriptCore
import Foundation

@objc protocol KSDebugOperating : JSExport
{
	func dumpProperties(_ obj: JSValue)
}

@objc public class KSDebug : NSObject, KSDebugOperating
{
	private var mConsole = CNFileConsole(file: CNTextFile.stdout)

	public func dumpProperties(_ obj: JSValue) {
		let text = KSValueDescription(value: obj)
		text.print(console: mConsole)
	}

	public func registerToContext(context ctxt: JSContext){
		ctxt.setObject(self, forKeyedSubscript: NSString(string: "debug"))
	}
}

/**
 * Note: This object uses "console" methods
 */
/*
public class KSDebug
{
	public class func registerToContext(context ctxt: JSContext){
		registerGlobalContext(context: ctxt)
		registerDumpPropertiesMethod(context: ctxt)
	}

	private class func registerGlobalContext(context ctxt: JSContext){
		let stmt = "var debug = new Object() ;"
		ctxt.evaluateScript(stmt)
	}

	private class func registerDumpPropertiesMethod(context ctxt: JSContext){
		let stmt = "debug.dumpProperties = function(src){\n"
			 + "  for(var prop in src){\n"
			 + "    console.put(prop + \":\" + src[prop])\n"
			 + "  }\n"
			 + "}"
		ctxt.evaluateScript(stmt)
	}
}
*/

