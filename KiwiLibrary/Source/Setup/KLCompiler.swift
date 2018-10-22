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

public class KLApplicationCompiler: KLCompiler
{
	public init(application app: KEApplication) {
		super.init(process: app)
	}

	public var application: KEApplication {
		get {
			if let app = process as? KEApplication {
				return app
			} else {
				fatalError("Not KEApplication Objec")
			}
		}
	}

	public override func compile(config conf: KLConfig) {
		super.compile(config: conf)
		applyConfig(config: conf)
		defineFunctions(applicationKind: conf.kind)
	}

	private func applyConfig(config conf: KLConfig){
		log(string: "/* Apply config */\n")
		if let appconf = application.config {
			appconf.doVerbose     = conf.doVerbose
			appconf.useStrictMode = conf.doStrict
			appconf.scriptFiles   = conf.scriptFiles
		} else {
			process.console.error(string: "No config object")
		}
	}

	private func defineFunctions(applicationKind kind: KEConfig.ApplicationKind)
	{
		/* exit */
		let exitFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			let _ = self.application.exit(value)
			return JSValue(undefinedIn: self.process.context)
		}
		defineGlobalFunction(name: "exit", function: exitFunc)
	}
}

open class KLCompiler: KECompiler
{
	public override init(process proc: KEProcess) {
		super.init(process: proc)
	}

	open func compile(config conf: KLConfig)
	{
		self.doVerbose = conf.doVerbose

		setStrictMode(config: conf)

		defineEnumTypes()
		defineFunctions(applicationKind: conf.kind)
		defineClassObjects(applicationKind: conf.kind)
		defineConstructorFunctions()

		guard let program = process.program else {
			process.console.error(string: "No program object")
			return
		}
		definePrimitiveFactories(program: program)

		guard let loader = program.objectLoader else {
			process.console.error(string: "No object loader")
			return
		}
		defineRequireFunction(objectLoader: loader)
	}

	private func setStrictMode(config conf: KLConfig){
		if conf.doStrict {
			let _ = compile(statement: "'use strict' ;")
		}
	}

	private func defineEnumTypes(){
		let console = process.console
		let context = process.context

		guard let program = process.program else {
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
			return JSValue(bool: result, in: self.process.context)
		}
		defineGlobalFunction(name: "isUndefined", function: isUndefinedFunc)

		/* isNull */
		let isNullFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			let result: Bool = value.isNull
			return JSValue(bool: result, in: self.process.context)
		}
		defineGlobalFunction(name: "isNull", function: isNullFunc)

		/* isBoolean */
		let isBooleanFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			let result: Bool = value.isBoolean
			return JSValue(bool: result, in: self.process.context)
		}
		defineGlobalFunction(name: "isBoolean", function: isBooleanFunc)

		/* isNumber */
		let isNumberFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			let result: Bool = value.isNumber
			return JSValue(bool: result, in: self.process.context)
		}
		defineGlobalFunction(name: "isNumber", function: isNumberFunc)

		/* isString */
		let isStringFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			let result: Bool = value.isString
			return JSValue(bool: result, in: self.process.context)
		}
		defineGlobalFunction(name: "isString", function: isStringFunc)

		/* isObject */
		let isObjectFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			let result: Bool = value.isObject
			return JSValue(bool: result, in: self.process.context)
		}
		defineGlobalFunction(name: "isObject", function: isObjectFunc)

		/* isArray */
		let isArrayFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			let result: Bool = value.isArray
			return JSValue(bool: result, in: self.process.context)
		}
		defineGlobalFunction(name: "isArray", function: isArrayFunc)

		/* isDate */
		let isDateFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			let result: Bool = value.isArray
			return JSValue(bool: result, in: self.process.context)
		}
		defineGlobalFunction(name: "isDate", function: isDateFunc)
	}

	private func defineClassObjects(applicationKind kind: KEConfig.ApplicationKind)
	{
		let context = process.context
		let console = KLConsole(context: context, console: process.console)

		defineGlobalObject(name: "console", object: console)

		let pipe = KLPipe(context: context)
		defineGlobalObject(name: "Pipe", object: pipe)

		let json = KLJSON(context: context)
		defineGlobalObject(name: "JSON", object: json)

		#if os(OSX)
			let shellobj = KLShell(context: context)
			defineGlobalObject(name: "Shell", object: shellobj)
		#endif

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

				let cursesobj = KLCurses(context: context)
				defineGlobalObject(name: "Curses", object: cursesobj)
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
			let context = self.process.context
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
		if let consval = JSValue(object: obj, in: process.context) {
			defineGlobalVariable(variableName: nm, value: consval)
		} else {
			error(message: "Failed to allocate object for \(nm)")
		}
	}

	public func defineGlobalFunction(name nm: String, function obj: Any){
		if let val = JSValue(object: obj, in: process.context){
			defineGlobalVariable(variableName: nm, value: val)
		} else {
			error(message: "Failed to allocate object for \(nm)")
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
					if let val = loader.require(modelName: cname, in: KLCompiler.self) {
						return val
					}
				}
			}
			return JSValue(nullIn: self.process.context)
		}
		if let funcval = JSValue(object: require, in: process.context) {
			process.context.set(name: "require", value: funcval)
		} else {
			error(message: "Failed to allocate require function")
		}
	}
}



