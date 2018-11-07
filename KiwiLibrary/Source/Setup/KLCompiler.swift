/**
 * @file	KLCompiler.swift
 * @brief	Define KLCompiler class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

open class KLCompiler: KECompiler
{
	private var 	mConsole:	CNConsole
	private var	mConfig:	KLConfig

	public init(console cons: CNConsole, config conf: KLConfig) {
		mConsole	= cons
		mConfig		= conf
		super.init(console: cons, config: conf)
	}

	public var console: CNConsole { get { return mConsole }}
	public var config: KLConfig { get { return mConfig }}
	
	open override func compile(context ctxt: KEContext) -> Bool {
		guard super.compile(context: ctxt) else {
			return false
		}

		defineFunctions(context: ctxt)
		defineClassObjects(context: ctxt)
		defineObjects(context: ctxt)
		defineConstructors(context: ctxt)

		return true
	}

	private func defineFunctions(context ctxt: KEContext) {
		/* isUndefined */
		let isUndefinedFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			let result: Bool = value.isUndefined
			return JSValue(bool: result, in: ctxt)
		}
		ctxt.set(name: "isUndefined", function: isUndefinedFunc)

		/* isNull */
		let isNullFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			let result: Bool = value.isNull
			return JSValue(bool: result, in: ctxt)
		}
		ctxt.set(name: "isNull", function: isNullFunc)

		/* isBoolean */
		let isBooleanFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			let result: Bool = value.isBoolean
			return JSValue(bool: result, in: ctxt)
		}
		ctxt.set(name: "isBoolean", function: isBooleanFunc)

		/* isNumber */
		let isNumberFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			let result: Bool = value.isNumber
			return JSValue(bool: result, in: ctxt)
		}
		ctxt.set(name: "isNumber", function: isNumberFunc)

		/* isString */
		let isStringFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			let result: Bool = value.isString
			return JSValue(bool: result, in: ctxt)
		}
		ctxt.set(name: "isString", function: isStringFunc)

		/* isObject */
		let isObjectFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			let result: Bool = value.isObject
			return JSValue(bool: result, in: ctxt)
		}
		ctxt.set(name: "isObject", function: isObjectFunc)

		/* isArray */
		let isArrayFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			let result: Bool = value.isArray
			return JSValue(bool: result, in: ctxt)
		}
		ctxt.set(name: "isArray", function: isArrayFunc)

		/* isDate */
		let isDateFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			let result: Bool = value.isArray
			return JSValue(bool: result, in: ctxt)
		}
		ctxt.set(name: "isDate", function: isDateFunc)
	}

	private func defineClassObjects(context ctxt: KEContext) {
		switch mConfig.kind {
		case .Terminal:
			#if os(OSX)
				/* Pipe */
				let pipe = KLPipe(context: ctxt)
				ctxt.set(name: "Pipe", object: pipe)

				/* File */
				let file = KLFile(context: ctxt)
				ctxt.set(name: "File", object: file)

				let stdinobj = file.standardFile(fileType: .input, context: ctxt)
				ctxt.set(name: "stdin", object: stdinobj)

				let stdoutobj = file.standardFile(fileType: .output, context: ctxt)
				ctxt.set(name: "stdout", object: stdoutobj)

				let stderrobj = file.standardFile(fileType: .error, context: ctxt)
				ctxt.set(name: "stderr", object: stderrobj)

				let cursesobj = KLCurses(context: ctxt)
				ctxt.set(name: "Curses", object: cursesobj)
			#endif /* if os(OSX) */
			break
		case .Window:
			break
		}

		#if os(OSX)
			/* Process */
			let process = KLProcess(context: ctxt, config: mConfig)
			ctxt.set(name: "Process", object: process)
		#endif

		/* JSON */
		let json = KLJSON(context: ctxt)
		ctxt.set(name: "JSON", object: json)

		/* Shell (OSX) */
		#if os(OSX)
			let shellobj = KLShell(context: ctxt)
			ctxt.set(name: "Shell", object: shellobj)
		#endif
	}

	private func defineObjects(context ctxt: KEContext) {
		/* Console */
		let console = KLConsole(context: ctxt, console: mConsole)
		ctxt.set(name: "console", object: console)
	}

	private func defineConstructors(context ctxt: KEContext) {
		/* URL */
		let urlFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			if value.isString {
				if let str = value.toString() {
					if let urlobj = KLURL.constructor(filePath: str, context: ctxt) {
						return JSValue(object: urlobj, in: ctxt)
					}
				}
			}
			return JSValue(nullIn: ctxt)
		}
		ctxt.set(name: "URL", function: urlFunc)
	}
}

