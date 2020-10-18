/*
 * @file	UTSuspend.swift
 * @brief	Unit test for suspend/resume function
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

import KiwiLibrary
import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

public func UTSuspend(context ctxt: KEContext, console cons: CNFileConsole) -> Bool
{
	let script0 = "console.log(\"[Main] Start suspend\") ; \n"
	ctxt.evaluateScript(script0)

	DispatchQueue.global(qos: .background).async {
		let script1 = "console.log(\"[Thread] Begin suspend\") ;\n"
		ctxt.evaluateScript(script1)
		let script2 = "suspend() ;\n"
			    + "console.log(\"[Thread] End suspend\") ;\n" ;
		ctxt.evaluateScript(script2)
	}

	sleep(3)
	cons.print(string: "[Main] Resume by system\n")
	ctxt.resume()

	let script3 = "console.log(\"[Main] Suspend done\") ; \n"
	ctxt.evaluateScript(script3)

	return true
}

