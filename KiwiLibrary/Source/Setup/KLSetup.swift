/**
 * @file	KLSetup.swift
 * @brief	Extend KLSetup class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import KiwiEngine
import JavaScriptCore
import Canary
import Foundation

public func KLSetupLibrary(context ctxt: KEContext, console cons: CNCursesConsole, terminateHandler termhdl: @escaping (_ code:Int32) -> Int32, config cfg: KLConfig)
{
	/* Setup module manager */
	let manager = KLModuleManager.shared
	manager.setup(context: ctxt, console: cons, terminateHandler: termhdl)

	/* Add process module */
	if let process = manager.getModule(moduleName: "process") as? KLProcess {
		ctxt.setObject(process, forKeyedSubscript: NSString(string: "Process"))
	} else {
		NSLog("Failed to allocate \"Process\" module")
		return
	}

	/* Add color module */
	if let color = manager.getModule(moduleName: "color") as? KLColor {
		ctxt.setObject(color, forKeyedSubscript: NSString(string: "Color"))
	} else {
		NSLog("Failed to allocate \"Color\" module")
		return
	}

	/* Add console module */
	if let console = manager.getModule(moduleName: "console") as? KLConsole {
		ctxt.setObject(console, forKeyedSubscript: NSString(string: "console"))
	} else {
		NSLog("Failed to allocate \"console\" module")
		return
	}

	/* Add File lib  */
	if cfg.hasFileLib {
		KLSetupFileLibrary(context: ctxt)
	}
	/* Add JSON lib */
	if cfg.hasJSONLib {
		KLSetupJSONLibrary(context: ctxt)
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

private func KLSetupJSONLibrary(context ctxt: KEContext)
{
	let jsonobj = KLJSON(context: ctxt)
	ctxt.setObject(jsonobj, forKeyedSubscript: NSString(string: "JSON"))
}

