/**
 * @file	UTScriptManager.swift
 * @brief	Test function for KHScriptManager class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import KiwiShell
import KiwiLibrary
import CoconutData
import CoconutShell
import Foundation

public func UTScriptManager(console cons: CNConsole) -> Bool
{
	let manager = KLBuiltinScripts.shared
	let names   = manager.scriptNames().sorted()
	cons.print(string: "names: ")
	for name in names {
		cons.print(string: "\(name) ")
	}
	cons.print(string: "\n")
	return true
}

