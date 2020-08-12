/*
 * @file	UTApplication.swift
 * @brief	Unit test for KLApplication class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import KiwiLibrary
import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

public func UTApplication(context ctxt: KEContext, console cons: CNFileConsole) -> Bool
{
	#if false
		let res0 = launchApplication(context: ctxt, console: cons)
	#else
		let res0 = true
	#endif
	return res0
}

private func launchApplication(context ctxt: KEContext, console cons: CNFileConsole) -> Bool {
	let appurl: URL? = URL(fileURLWithPath: "/System/Applications/TextEdit.app")
	let docurl: URL? = URL(fileURLWithPath: "Info.plist")
	if let runapp = CNRemoteApplication.launch(application: appurl, document: docurl) {
		let app = KLApplication(applicationInfo: runapp, context: ctxt)
		let name = app.name()
		cons.print(string: "Launch ... \(String(describing: name.toString()))\n")
	} else {
		cons.print(string: "[Error] Failed to launch\n")
	}
	return true
}

