/**
 * @file	KLSetup.swift
 * @brief	Extend KLSetup class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import KiwiEngine
import Canary
import Foundation

public func KLSetupLibrary(context ctxt: KEContext, console cons: CNConsole, config cfg: KLConfig)
{
	if cfg.hasConsole {
		let consobj = KLConsole(console: cons)
		ctxt.setObject(consobj, forKeyedSubscript: NSString(string: "console"))
	}
}

