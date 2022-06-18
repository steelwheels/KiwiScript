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
	let res2 = normalizePath(fileManager: manager, context: ctxt, console: cons)
	let res3 = accessibilityTest(fileManager: manager, context: ctxt, console: cons)
	let res4 = currentDirectoryTest(fileManager: manager, context: ctxt, console: cons)
	let summary = res0 && res1 && res2 && res3 && res4
	if summary {
		cons.print(string: "UTFileManager ... OK\n")
	} else {
		cons.print(string: "UTFileManager ... NG\n")
	}
	return summary
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
		switch Int(typeval.toInt32()) {
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
		if let url = res.toURL() {
			cons.print(string: "normalize: \(p1) + \(p2) => \(url.path)\n")
			result = true
		}
	} else {
		cons.print(string: "[Error] can not allocate parameter")
	}
	return result
}

private func accessibilityTest(fileManager manager: KLFileManager, context ctxt: KEContext, console cons: CNConsole) -> Bool
{
	if let pathval = JSValue(object: FileManager.default.currentDirectoryPath + "/UnitTest", in: ctxt),
	   let accval  = JSValue(int32: Int32(CNFileAccessType.ReadAccess.rawValue), in: ctxt) {
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

private func printCurrentDirectory(fileManager manager: KLFileManager, console cons: CNConsole) -> Bool {
	let result: Bool
	let pathval = manager.currentDirectory()
	if pathval.isURL {
		if let url = pathval.toURL() {
			cons.print(string: "current directory: \(url.absoluteString)\n")
			result = true
		} else {
			result = false
		}
	} else {
		cons.print(string: "Failed to get current director\n")
		result = false
	}
	return result
}

private func changeCurrentDirectory(fileManager manager: KLFileManager, changePath path: String, context ctxt: KEContext, console cons: CNConsole) -> Bool {
	let result: Bool
	let resval = manager.setCurrentDirectory(JSValue(object: path, in: ctxt))
	if resval.isBoolean {
		if resval.toBool() {
			if printCurrentDirectory(fileManager: manager, console: cons) {
				result = true
			} else {
				result = false
			}
		} else {
			cons.print(string: "Invalid result (not true)\n")
			result = false
		}
	} else {
		cons.print(string: "Invalid result type (not boolean)\n")
		result = false
	}
	return result
}

private func currentDirectoryTest(fileManager manager: KLFileManager, context ctxt: KEContext, console cons: CNConsole) -> Bool
{
	var result = true

	/* Get current directory */
	if !printCurrentDirectory(fileManager: manager, console: cons) {
		result = false
	}

	/* move to parent */
	if !changeCurrentDirectory(fileManager: manager, changePath: "..", context: ctxt, console: cons) {
		result = false
	}

	/* move to "Debug" directory */
	if !changeCurrentDirectory(fileManager: manager, changePath: "./Debug", context: ctxt, console: cons) {
		result = false
	}

	return result
}


