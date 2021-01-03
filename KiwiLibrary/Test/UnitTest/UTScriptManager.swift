/*
 * @file	UTScriptManager.swift
 * @brief	Unit test for KLScriptManager class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import KiwiLibrary
import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

public func UTScriptManager(console cons: CNConsole) -> Bool
{
	let manager = KLBuiltinScripts()
	manager.setup(subdirectory: nil, bundleName: "UnitTest")

	let names = manager.scriptNames()
	cons.print(string: "ScriptManager\n")
	for name in names.sorted() {
		cons.print(string: " - script: \(name)\n")
	}
	return true
}

