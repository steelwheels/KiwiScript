/*
 * @file	UTFileManager.swift
 * @brief	Test KLFileManager class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import KiwiLibrary
import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

public func UTFileManager(fileManager manager: KLFileManager, context ctxt: KEContext, console cons: CNConsole) -> Bool
{
	cons.print(string: "Home directory:\n")
	let res0 = printURL(URLValue: manager.homeDirectory(), fileManager: manager, console: cons)
	let res1 = printURL(URLValue: manager.temporaryDirectory(), fileManager: manager, console: cons)
	return res0 && res1
}

private func printURL(URLValue val: JSValue, fileManager manager: KLFileManager, console cons: CNConsole) -> Bool
{
	if val.isURL {
		//let url = val.toURL()
		//cons.print(string: "  * path: \(url.path)\n")
		cons.print(string: "  * path: <skipped>\n")
		cons.print(string: "    isReadable:   " + valueToBoolString(boolValue: manager.isReadable(val)) + "\n")
		cons.print(string: "    isWritable:   " + valueToBoolString(boolValue: manager.isWritable(val)) + "\n")
		cons.print(string: "    isExecutable: " + valueToBoolString(boolValue: manager.isExecutable(val)) + "\n")
		cons.print(string: "    isDeletable:  " + valueToBoolString(boolValue: manager.isDeletable(val)) + "\n")
		return true
	}
	return false
}

private func valueToBoolString(boolValue val: JSValue) -> String {
	var result: String = "unknown"
	if val.isBoolean {
		if val.toBool() {
			result = "true"
		} else {
			result = "false"
		}
	}
	return result
}

