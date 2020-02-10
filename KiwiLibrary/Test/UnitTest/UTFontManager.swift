/*
 * @file	UTFontManager.swift
 * @brief	Test KLFontManager class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import KiwiLibrary
import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

public func UTFontManager(context ctxt: KEContext, console cons: CNConsole) -> Bool
{
	var result: Bool = true

	cons.print(string: "[Available fonts]\n")
	let manager = KLFontManager(context: ctxt)
	let nameval = manager.availableFonts
	if let names = nameval.toArray() {
		for nameval in names {
			if let name = nameval as? String {
				cons.print(string: "\(name)\n")
			} else {
				cons.print(string: "[Error] Invalida data type\n")
				result = false
			}
		}
	} else {
		cons.print(string: "[Error] Failed to get names\n")
		result = false
	}

	return result
}

