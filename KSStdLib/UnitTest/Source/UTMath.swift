//
//  UTMath.swift
//  KSStdLib
//
//  Created by Tomoo Hamada on 2015/10/27.
//  Copyright © 2015年 Steel Wheels Project. All rights reserved.
//

import Foundation
import JavaScriptCore
import KSStdLib
import Canary

public func testMath() -> Bool
{
	let context = JSContext()
	let console = CNTextConsole()
	KSSetupStdLib(context, console: console)
	
	context.exceptionHandler = { context, exception in
		print("JavaScript Error: \(exception)")
	}
	
	context.evaluateScript(
		  "console.put(\"PI = \" + Math.PI);"
		+ "console.put(\"sin(PI/2) = \" + Math.sin(Math.PI/2)) ;"
		+ "console.put(\"cos(PI/2) = \" + Math.cos(Math.PI/2)) ;"
	) ;
	return true
}

