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
		defineFunctions(applicationKind: conf.kind)
		defineClassObjects(applicationKind: conf.kind)
		defineConstructorFunctions()

		guard let program = application.program else {
			console.error(string: "No program object")
			return
		}
		definePrimitiveFactories(program: program)

		guard let loader = program.objectLoader else {
			console.error(string: "No object loader")
			return
		}
		defineRequireFunction(objectLoader: loader)
	}

	private func applyConfig(config conf: KLConfig){
		log(string: "/* Apply config */\n")
		if let appconf = application.config {
			appconf.doVerbose     = conf.doVerbose
			appconf.useStrictMode = conf.doStrict
			appconf.scriptFiles   = conf.scriptFiles
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

		/* Alignment */
		let align =  KLAlignment(instanceName: "Alignment", context: context)
		compile(enumObject: align, enumTable: etable)

		/* Color */
		let color = KLColor(instanceName: "Color", context: context)
		compile(enumObject: color, enumTable: etable)

		/* Authorize */
		let authorize = KLAuthorize(instanceName: "Authorize", context: context)
		compile(enumObject: authorize, enumTable: etable)
	}

	private func defineFunctions(applicationKind kind: KEConfig.ApplicationKind)
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

		/* exit */
		let exitFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			let _ = self.application.exit(value)
			return JSValue(undefinedIn: self.context)
		}
		defineGlobalFunction(name: "exit", function: exitFunc)
	}

	private func defineClassObjects(applicationKind kind: KEConfig.ApplicationKind)
	{
		let console = KLConsole(context: self.context, console: self.console)
		defineGlobalObject(name: "console", object: console)

		let pipe = KLPipe(context: self.context)
		defineGlobalObject(name: "Pipe", object: pipe)

		let json = KLJSON(context: self.context)
		defineGlobalObject(name: "JSON", object: json)

		switch kind {
		case .Terminal:
			#if os(OSX)
			/* File */
			let file = KLFile(context: context)
			defineGlobalObject(name: "File", object: file)

			let stdinobj = file.standardFile(fileType: .input, context: context)
			defineGlobalObject(name: "stdin", object: stdinobj)

			let stdoutobj = file.standardFile(fileType: .output, context: context)
			defineGlobalObject(name: "stdout", object: stdoutobj)

			let stderrobj = file.standardFile(fileType: .error, context: context)
			defineGlobalObject(name: "stderr", object: stderrobj)

			/* Curses */
			let cursesobj = KLCurses(context: context)
			defineGlobalObject(name: "Curses", object: cursesobj)

			/* Shell */
			let shellobj = KLShell(context: context)
			defineGlobalObject(name: "Shell", object: shellobj)
			#else
			break
			#endif
		case .Window:
			break
		}
	}

	private func defineConstructorFunctions()
	{
		/* URL */
		let urlFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			let context = self.context
			if value.isString {
				if let str = value.toString() {
					if let urlobj = KLURL.constructor(filePath: str, context: context) {
						return JSValue(object: urlobj, in: context)
					}
				}
			}
			return JSValue(nullIn: context)
		}
		defineGlobalFunction(name: "URL", function: urlFunc)
	}

	private func defineGlobalObject(name nm: String, object obj: JSExport)
	{
		if let consval = JSValue(object: obj, in: self.context) {
			defineGlobalVariable(variableName: nm, value: consval)
		} else {
			NSLog("Failed to allocate object for \(nm)")
		}
	}

	private func defineGlobalFunction(name nm: String, function obj: Any){
		if let val = JSValue(object: obj, in: context){
			defineGlobalVariable(variableName: nm, value: val)
		} else {
			NSLog("Failed to allocate object for \(nm)")
		}
	}

	private func definePrimitiveFactories(program prg: KEProgram) {
		if let factory = prg.primitiveFactory {
			factory.addAllocator(typeName: "URL", parameterType: .StringType, allocator:{
				(_ value: CNValue, _ context: KEContext) -> JSValue? in
				if let str = value.stringValue {
					let urlobj = KLURL.constructor(filePath: str, context: context)
					return JSValue(object: urlobj, in: context)
				} else {
					return nil
				}
			})
		}
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
					if let val = loader.require(modelName: cname, in: KLLibraryCompiler.self) {
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



