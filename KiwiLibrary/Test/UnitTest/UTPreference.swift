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
	let pref   = KLPreference(context: ctxt)

	/* Ger version */
	var hasversion = false
	let sysval = pref.system
	if let sysobj = sysval.toObject() as? KLSystemPreference {
		let verval = sysobj.version
		if let verstr = verval.toString() {
			cons.print(string: "preference.system.version = \(verstr)\n")
			hasversion = true
		}
	}
	if !hasversion {
		cons.print(string: "[Error] Failed to get version\n")
	}

	/* Get home directory */
	var hashome = false
	let userval = pref.user
	if let userobj = userval.toObject() as? KLUserPreference {
		let homeval = userobj.homeDirectory
		if let homeurl = homeval.toURL() {
			cons.print(string: "preference.user.homeDirectory = \(homeurl.path)\n")
			hashome = true
		}
	}
	if !hashome {
		cons.print(string: "[Error] Failed to get home directory\n")
	}


	return hasversion && hashome
}

