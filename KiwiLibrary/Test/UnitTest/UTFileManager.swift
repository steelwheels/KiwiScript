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
	let res2 = printURL(URLValue: manager.resourceDirectory(JSValue(object: "Library", in: ctxt)), fileManager: manager, console: cons)
	let res3 = normalizePath(fileManager: manager, context: ctxt, console: cons)
	let res4 = accessibilityTest(fileManager: manager, context: ctxt, console: cons)
	return res0 && res1 && res2 && res3 && res4
}

private func printURL(URLValue val: JSValue, fileManager manager: KLFileManager, console cons: CNConsole) -> Bool
{
	var result = true
	if val.isURL {
		//let url = val.toURL()
		//cons.print(string: "  * path: \(url.path)\n")
		cons.print(string: "  * path: <skipped>\n")
		cons.print(string: "    isReadable:   " + valueToBoolString(boolValue: manager.isReadable(val)) + "\n")
		cons.print(string: "    isWritable:   " + valueToBoolString(boolValue: manager.isWritable(val)) + "\n")
		cons.print(string: "    isExecutable: " + valueToBoolString(boolValue: manager.isExecutable(val)) + "\n")
		cons.print(string: "    isDeletable:  " + valueToBoolString(boolValue: manager.isDeletable(val)) + "\n")
	} else {
		result = false
	}

	let typeval = manager.checkFileType(val)
	if typeval.isNumber {
		switch typeval.toInt32() {
		case CNFileType.File.rawValue:
			cons.print(string: "FileType: File\n")
		case CNFileType.Directory.rawValue:
			cons.print(string: "FileType: Directory\n")
		case CNFileType.NotExist.rawValue:
			cons.print(string: "FileType: Not exit\n")
		default:
			cons.print(string: "FileType: Unknown\n")
			result = false
		}
	} else {
		cons.print(string: "[Error] Unexpected file type: \(typeval.description)")
		result = false
	}

	return result
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

private func normalizePath(fileManager manager: KLFileManager, context ctxt: KEContext, console cons: CNConsole) -> Bool
{
	let res0 = normalizeTest(fileManager: manager, context: ctxt, console: cons, path1: "/home/user", path2: "tmp")
	let res1 = normalizeTest(fileManager: manager, context: ctxt, console: cons, path1: "/home/user/tmp", path2: "..")
	return res0 && res1
}

private func normalizeTest(fileManager manager: KLFileManager, context ctxt: KEContext, console cons: CNConsole, path1 p1: String, path2 p2:String) -> Bool
{
	var result = false
	if let val1 = JSValue(object: p1, in: ctxt), let val2 = JSValue(object: p2, in: ctxt) {
		let res = manager.normalizePath(val1, val2)
		cons.print(string: "normalize: \(p1) + \(p2) => \(res.toURL().path)\n")
		result = true
	} else {
		cons.print(string: "[Error] can not allocate parameter")
	}
	return result
}

private func accessibilityTest(fileManager manager: KLFileManager, context ctxt: KEContext, console cons: CNConsole) -> Bool
{
	if let pathval = JSValue(object: FileManager.default.currentDirectoryPath + "/Info.plist", in: ctxt),
	   let accval  = JSValue(int32: CNFileAccessType.ReadAccess.rawValue, in: ctxt) {
		let retval  = manager.isAccessible(pathval, accval)
		if retval.isBoolean {
			if retval.toBool() {
				cons.print(string: "Expected value: true\n")
				return true
			} else {
				cons.print(string: "[Error] Unexpected value: false\n")
			}
		} else {
			cons.print(string: "[Error] Invalud return value: \(retval.description)\n")
		}
	} else {
		cons.print(string: "[Error] Invalid parameters\n")
	}
	return false
}

