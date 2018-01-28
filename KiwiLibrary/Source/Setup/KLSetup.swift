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

	/* Add "require" function */
	let require = KLAllocateRequireFunction(context: ctxt)
	ctxt.setObject(require, forKeyedSubscript: NSString(string: "require"))

	/* Add process module */
	if let process = manager.getBuiltinModule(moduleName: "process") as? KLProcess {
		ctxt.setObject(process, forKeyedSubscript: NSString(string: "Process"))
	} else {
		NSLog("Failed to allocate \"Process\" module")
		return
	}

	/* Add color module */
	if let color = manager.getBuiltinModule(moduleName: "color") as? KLColor {
		ctxt.setObject(color, forKeyedSubscript: NSString(string: "Color"))
	} else {
		NSLog("Failed to allocate \"Color\" module")
		return
	}

	/* Add align module */
	if let align = manager.getBuiltinModule(moduleName: "align") as? KLAlign {
		ctxt.setObject(align, forKeyedSubscript: NSString(string: "Align"))
	} else {
		NSLog("Failed to allocate \"Align\" module")
		return
	}


	/* Add console module */
	if let console = manager.getBuiltinModule(moduleName: "console") as? KLConsole {
		ctxt.setObject(console, forKeyedSubscript: NSString(string: "console"))
	} else {
		NSLog("Failed to allocate \"console\" module")
		return
	}

	/* Add File module  */
	if let file = manager.getBuiltinModule(moduleName: "file") as? KLFile {
		ctxt.setObject(file, forKeyedSubscript: NSString(string: "File"))

		let stdinobj = KLFile.standardFile(fileType: .input, context: ctxt)
		ctxt.setObject(stdinobj, forKeyedSubscript: NSString(string: "stdin"))

		let stdoutobj = KLFile.standardFile(fileType: .output, context: ctxt)
		ctxt.setObject(stdoutobj, forKeyedSubscript: NSString(string: "stdout"))

		let stderrobj = KLFile.standardFile(fileType: .error, context: ctxt)
		ctxt.setObject(stderrobj, forKeyedSubscript: NSString(string: "stderr"))
	} else {
		NSLog("Failed to allocate \"console\" module")
		return
	}

	/* Add JSON lib */
	//KLSetupJSONLibrary(context: ctxt)
}

private func KLSetupJSONLibrary(context ctxt: KEContext)
{
	let jsonobj = KLJSON(context: ctxt)
	ctxt.setObject(jsonobj, forKeyedSubscript: NSString(string: "JSON"))
}

