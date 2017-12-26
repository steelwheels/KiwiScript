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
	if cfg.hasFile {
		KLSetupFileLibrary(context: ctxt)
	}
}

private func KLSetupFileLibrary(context ctxt: KEContext)
{
	let fileobj = KLFile(context: ctxt)
	ctxt.setObject(fileobj, forKeyedSubscript: NSString(string: "File"))

	let stdinobj = KLFile.standardFile(fileType: .input, context: ctxt)
	ctxt.setObject(stdinobj, forKeyedSubscript: NSString(string: "stdin"))

	let stdoutobj = KLFile.standardFile(fileType: .output, context: ctxt)
	ctxt.setObject(stdoutobj, forKeyedSubscript: NSString(string: "stdout"))

	let stderrobj = KLFile.standardFile(fileType: .error, context: ctxt)
	ctxt.setObject(stderrobj, forKeyedSubscript: NSString(string: "stderr"))
}
