//
//  UTValueType.swift
//  KSStdLib
//
//  Created by Tomoo Hamada on 2015/10/15.
//  Copyright © 2015年 Steel Wheels Project. All rights reserved.
//

import Foundation
import JavaScriptCore
import Canary
import KSStdLib

public func testKSValueType() -> Bool {
	let context = JSContext()
	let console = CNTextConsole()
	
	print("*** var var0 = 1")
	executeScript(console, context: context, name:"var0", code:"var var0=1")
	print("*** var var1 = 1.23")
	executeScript(console, context: context, name:"var1", code:"var var1=1.23")
	print("*** var var2 = [\"A\" , \"B\" , \"C\" , 123 , 456 , true , false];")
	executeScript(console, context: context, name:"var2", code:"var var2 = [\"A\" , \"B\" , \"C\" , 123 , 456 , true , false];")
	
	return true
}

private func executeScript(console : CNConsole, context: JSContext, name: String, code: String)
{
	context.evaluateScript(code)
	if let retval : JSValue = context.objectForKeyedSubscript(name) {
		let line = KSValueDescription.description(value: retval)
		console.print(text: CNConsoleText(string: line))
	} else {
		print("11")
	}
}
