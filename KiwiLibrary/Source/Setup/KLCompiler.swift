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

public class KLLibraryCompiler: KECompiler
{
	public override init(application app: KEApplication) {
		super.init(application: app)
	}

	public func compile(config conf: KLConfig)
	{
		applyConfig(config: conf)
		setStrictMode()
		defineEnumTypes()
		defineGlobalFunctions()

		guard let program = application.program else {
			console.error(string: "No program object")
			return
		}
		guard let manager = program.objectManager else {
			console.error(string: "No object manager")
			return
		}
		defineObjectAllocators(objectManager: manager)
		allocateRequireFunction(objectManager: manager)
	}

	private func applyConfig(config conf: KLConfig){
		log(string: "/* Apply config */\n")
		if let appconf = application.config {
			appconf.doVerbose     = conf.verboseMode
			appconf.useStrictMode = conf.useStrictMode
		} else {
			console.error(string: "No config object")
		}
	}

	private func setStrictMode(){
		if let config = application.config {
			if config.useStrictMode {
				let _ = compile(statement: "'use strict' ;")
			}
		}
	}

	private func defineEnumTypes(){
		/* Align */
		let align =  KLAlign(instanceName: "Align", context: context)
		compile(enumObject: align)

		/* Orientation */
		let orientation = KLOrientation(instanceName: "Orientation", context: context)
		compile(enumObject: orientation)

		/* Color */
		let color = KLColor(instanceName: "Color", context: context)
		compile(enumObject: color)

		/* Authorize */
		let authorize = KLAuthorize(instanceName: "Authorize", context: context)
		compile(enumObject: authorize)
	}

	private func defineGlobalFunctions()
	{
		/* isUndefined */
		let isUndefinedFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			let result: Bool = value.isUndefined
			return JSValue(bool: result, in: self.context)
		}
		defineGlobalFunction(name: "isUndefined", function: isUndefinedFunc)

		/* isNull */
		let isNullFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			let result: Bool = value.isNull
			return JSValue(bool: result, in: self.context)
		}
		defineGlobalFunction(name: "isNull", function: isNullFunc)

		/* isBoolean */
		let isBooleanFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			let result: Bool = value.isBoolean
			return JSValue(bool: result, in: self.context)
		}
		defineGlobalFunction(name: "isBoolean", function: isBooleanFunc)

		/* isNumber */
		let isNumberFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			let result: Bool = value.isNumber
			return JSValue(bool: result, in: self.context)
		}
		defineGlobalFunction(name: "isNumber", function: isNumberFunc)

		/* isString */
		let isStringFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			let result: Bool = value.isString
			return JSValue(bool: result, in: self.context)
		}
		defineGlobalFunction(name: "isString", function: isStringFunc)

		/* isObject */
		let isObjectFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			let result: Bool = value.isObject
			return JSValue(bool: result, in: self.context)
		}
		defineGlobalFunction(name: "isObject", function: isObjectFunc)

		/* isArray */
		let isArrayFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			let result: Bool = value.isArray
			return JSValue(bool: result, in: self.context)
		}
		defineGlobalFunction(name: "isArray", function: isArrayFunc)

		/* isDate */
		let isDateFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			let result: Bool = value.isArray
			return JSValue(bool: result, in: self.context)
		}
		defineGlobalFunction(name: "isDate", function: isDateFunc)
	}

	private func defineGlobalFunction(name nm: String, function obj: Any){
		if let val = JSValue(object: obj, in: context){
			defineGlobalVariable(variableName: nm, value: val)
		} else {
			NSLog("Failed to allocate object for \(nm)")
		}
	}

	private func defineObjectAllocators(objectManager manager: KEObjectManager)
	{
		/* KLFile */
		manager.addAllocator(className: "file", allocator: {
			(_ context: KEContext) -> JSExport in
			return KLFile(context: context)
		})
		/* KLPipe */
		manager.addAllocator(className: "pipe", allocator: {
			(_ context: KEContext) -> JSExport in
			return KLPipe(context: context)
		})
		/* KLJSON */
		manager.addAllocator(className: "JSON", allocator: {
			(_ context: KEContext) -> JSExport in
			return KLJSON(context: context)
		})
		/* KLContact */
		manager.addAllocator(className: "contact", allocator: {
			(_ context: KEContext) -> JSExport in
			return KLContact(context: context)
		})

		#if os(OSX)
		/* KLCurses */
		manager.addAllocator(className: "shell", allocator: {
			(_ context: KEContext) -> JSExport in
			return KLShell(context: context)
		})
		manager.addAllocator(className: "curses", allocator: {
			(_ context: KEContext) -> JSExport in
			return KLCurses(context: context)
		})
		#endif
	}

	private func allocateRequireFunction(objectManager manager: KEObjectManager)
	{
		/* define module object */
		let _ = compile(statement: "module = {} ;\n")

		let require: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			if value.isString {
				if let cname = value.toString() {
					if let val = manager.require(className: cname) {
						return val
					}
				}
			}
			return JSValue(nullIn: self.context)
		}
		if let funcval = JSValue(object: require, in: context) {
			log(string: "/* Define require function */\n")
			context.set(name: "require", value: funcval)
		} else {
			NSLog("Failed to allocate require function")
		}
	}
}

/*
public func KLSetupLibrary(context ctxt: KEContext, arguments args: Array<String>, console cons: CNConsole, config cfg: KLConfig, exceptionHandler ehandler: @escaping (_ exception: KEException) -> Void)
{

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
*/


