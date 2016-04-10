//
//  UTConsole.swift
//  KSStdLib
//
//  Created by Tomoo Hamada on 2015/10/20.
//  Copyright © 2015年 Steel Wheels Project. All rights reserved.
//

import Foundation
import JavaScriptCore
import KSStdLib
import Canary

public func testConsole() -> Bool
{
	let context = JSContext()
	
	KSStdLib.setup(context)
	if let console = KSStdLib.console(context) {
		console.addOutput(CNTextConsole())
	} else {
		print("No console object")
		return false
	}
	
	context.exceptionHandler = { context, exception in
		print("JavaScript Error: \(exception)")
	}
	
	context.evaluateScript("console.put(\"Hello, world!!\");")
	
	return true
}
