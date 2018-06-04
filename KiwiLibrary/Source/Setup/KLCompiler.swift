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
		defineGlobalObjects(applicationKind: conf.kind)
		defineGlobalFunctions()

		guard let program = application.program else {
			console.error(string: "No program object")
			return
		}
		guard let loader = program.objectLoader else {
			console.error(string: "No object loader")
			return
		}
		defineLoadableObjects(objectLoader: loader)
		defineRequireFunction(objectLoader: loader)
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
		guard let program = application.program else {
			console.error(string: "No program in application")
			return
		}
		guard let etable = program.enumTable else {
			console.error(string: "No enum table in application")
			return
		}

		/* Align */
		let align =  KLAlign(instanceName: "Align", context: context)
		compile(enumObject: align, enumTable: etable)

		/* Orientation */
		let orientation = KLOrientation(instanceName: "Orientation", context: context)
		compile(enumObject: orientation, enumTable: etable)

		/* Color */
		let color = KLColor(instanceName: "Color", context: context)
		compile(enumObject: color, enumTable: etable)

		/* Authorize */
		let authorize = KLAuthorize(instanceName: "Authorize", context: context)
		compile(enumObject: authorize, enumTable: etable)
	}

	private func defineGlobalObjects(applicationKind kind: KLConfig.ApplicationKind)
	{
		let console = KLConsole(context: self.context, console: self.console)
		defineGlobalObject(name: "console", object: console)

		switch kind {
		case .TerminalApplication:
			#if os(OSX)
				/* Process */
				let process = KLProcess(context: context)
				defineGlobalObject(name: "Process", object: process)

				/* File */
				let file = KLFile(context: context)
				defineGlobalObject(name: "File", object: file)

				let stdinobj = file.standardFile(fileType: .input, context: context)
				defineGlobalObject(name: "stdin", object: stdinobj)

				let stdoutobj = file.standardFile(fileType: .output, context: context)
				defineGlobalObject(name: "stdout", object: stdoutobj)

				let stderrobj = file.standardFile(fileType: .error, context: context)
				defineGlobalObject(name: "stderr", object: stderrobj)
			#else
				break
			#endif
		case .GUIApplication:
			break
		}
	}

	private func defineGlobalObject(name nm: String, object obj: JSExport)
	{
		if let consval = JSValue(object: obj, in: self.context) {
			defineGlobalVariable(variableName: nm, value: consval)
		} else {
			NSLog("Failed to allocate object for \(nm)")
		}
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

	private func defineLoadableObjects(objectLoader loader: KEObjectLoader)
	{
		/* KLFile */
		loader.addAllocator(className: "file", allocator: {
			(_ context: KEContext) -> JSExport in
			return KLFile(context: context)
		})
		/* KLPipe */
		loader.addAllocator(className: "pipe", allocator: {
			(_ context: KEContext) -> JSExport in
			return KLPipe(context: context)
		})
		/* KLJSON */
		loader.addAllocator(className: "JSON", allocator: {
			(_ context: KEContext) -> JSExport in
			return KLJSON(context: context)
		})
		/* KLContact */
		loader.addAllocator(className: "contact", allocator: {
			(_ context: KEContext) -> JSExport in
			return KLContact(context: context)
		})

		#if os(OSX)
		/* KLCurses */
		loader.addAllocator(className: "shell", allocator: {
			(_ context: KEContext) -> JSExport in
			return KLShell(context: context)
		})
		loader.addAllocator(className: "curses", allocator: {
			(_ context: KEContext) -> JSExport in
			return KLCurses(context: context)
		})
		#endif
	}

	private func defineRequireFunction(objectLoader loader: KEObjectLoader)
	{
		log(string: "/* Define require function */\n")

		/* define module object */
		let _ = compile(statement: "module = {} ;\n")

		let require: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			if value.isString {
				if let cname = value.toString() {
					if let val = loader.require(className: cname, in: KLLibraryCompiler.self) {
						return val
					}
				}
			}
			return JSValue(nullIn: self.context)
		}
		if let funcval = JSValue(object: require, in: context) {
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


