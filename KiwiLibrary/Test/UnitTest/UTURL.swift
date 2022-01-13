/*
 * @file	UTURL.swift
 * @brief	Test KLURL class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

import KiwiLibrary
import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

public func UTURL(fileManager manager: KLFileManager, context ctxt: KEContext, console cons: CNConsole) -> Bool
{
	cons.print(string: "- test appendingPathComponent\n")
	var result = true
	let url0  = KLURL(URL: URL(fileURLWithPath: "/home/user"), context: ctxt)
	let val1  = url0.appendingPathComponent(JSValue(object: "Document/Script", in: ctxt))
	if val1.isURL {
		if let url1  = val1.toURL() {
			let path1 = url1.path
			cons.print(string: "  URL: \(path1)\n")
		}
	} else {
		result = false
	}
	return result
}

