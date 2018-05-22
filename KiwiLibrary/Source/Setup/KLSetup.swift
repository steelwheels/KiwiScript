/**
 * @file	KLSetup.swift
 * @brief	Define KLSetupLibrary function
 * @par Copyright
 *   Copyright (C) 2017-2018 Steel Wheels Project
 */

import KiwiEngine
import JavaScriptCore
import CoconutData
import Foundation

public func KLSetupLibrary(context ctxt: KEContext, arguments args: Array<String>, console cons: CNConsole, config cfg: KLConfig, exceptionHandler ehandler: @escaping (_ exception: KEException) -> Void)
{
	/* Set strict mode */
	if cfg.useStrictMode {
		ctxt.runScript(script: "'use strict' ;", exceptionHandler: {
			(_ result: KEException) -> Void in
			ehandler(result)
		})
	}

	/* Add "require" function */
	let require = KLAllocateRequireFunction(context: ctxt)
	ctxt.setObject(require, forKeyedSubscript: NSString(string: "require"))

	/* Setup global manager */
	let global = KLGlobalManager.shared
	global.setup(context: ctxt)
	global.setTypeCheckFunctions()

	/* Setup module manager */
	let manager = KLModuleManager.shared
	manager.setup(context: ctxt, arguments: args, console: cons, exceptionHandler: ehandler)

	/* Add process module */
	#if os(OSX)
	if let process = manager.getBuiltinModule(moduleName: "process") as? KLProcess {
		ctxt.setObject(process, forKeyedSubscript: NSString(string: "Process"))
	} else {
		NSLog("Failed to allocate \"Process\" module")
		return
	}
	#endif // os(OSX)

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

		let stdinobj = file.standardFile(fileType: .input, context: ctxt)
		ctxt.setObject(stdinobj, forKeyedSubscript: NSString(string: "stdin"))

		let stdoutobj = file.standardFile(fileType: .output, context: ctxt)
		ctxt.setObject(stdoutobj, forKeyedSubscript: NSString(string: "stdout"))

		let stderrobj = file.standardFile(fileType: .error, context: ctxt)
		ctxt.setObject(stderrobj, forKeyedSubscript: NSString(string: "stderr"))
	} else {
		NSLog("Failed to allocate \"file\" module")
		return
	}

	/* Add Pipe module */
	if let pipe = manager.getBuiltinModule(moduleName: "pipe") as? KLPipe {
		ctxt.setObject(pipe, forKeyedSubscript: NSString(string: "Pipe"))
	}
}

