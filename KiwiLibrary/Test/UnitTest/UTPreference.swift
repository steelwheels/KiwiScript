/*
 * @file	UTPreference.swift
 * @brief	Unit test for "KLPreference" class object
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

import KiwiEngine
import KiwiLibrary
import CoconutData
import Foundation

public func UTPreference(context ctxt: KEContext, console cons: CNFileConsole) -> Bool
{
	/* Ger version */
	var hasversion = false
	let pref   = KLPreference(context: ctxt)
	let sysval = pref.systemPreference
	if let sysobj = sysval.toObject() as? KLSystemPreference {
		let verval = sysobj.version
		if let verstr = verval.toString() {
			cons.print(string: "preference.system.version = \(verstr)\n")
			hasversion = true
		}
	}

	return hasversion
}

