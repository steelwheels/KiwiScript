/**
 * @file	KLSetup.swift
 * @brief	Extend KLSetup class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import KiwiEngine
import Canary
import Foundation

public func KLSetupLibrary(context ctxt: KEContext, console cons: CNCursesConsole, config cfg: KLConfig)
{
	KLSetupConsoleLibrary(context: ctxt, console: cons)

	/* Add process */
	let procobj = KLProcess(terminateHandler: {
		(_ code:Int32) -> Int32 in
		return code
	})
	ctxt.setObject(procobj, forKeyedSubscript: NSString(string: "Process"))

	/* Add File lib  */
	if cfg.hasFileLib {
		KLSetupFileLibrary(context: ctxt)
	}
	/* Add JSON lib */
	if cfg.hasJSONLib {
		KLSetupJSONLibrary(context: ctxt)
	}
}

private func KLSetupConsoleLibrary(context ctxt: KEContext, console cons: CNCursesConsole)
{
	let console = KLConsole(context: ctxt, console: cons)
	ctxt.setObject(console, forKeyedSubscript: NSString(string: "console"))

	let color = KLColor(context: ctxt)
	ctxt.setObject(color, forKeyedSubscript: NSString(string: "Color"))
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

private func KLSetupJSONLibrary(context ctxt: KEContext)
{
	let jsonobj = KLJSON(context: ctxt)
	ctxt.setObject(jsonobj, forKeyedSubscript: NSString(string: "JSON"))
}

