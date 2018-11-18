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
	open override func compile(context ctxt: KEContext, process proc: KEProcess) -> Bool {
		guard super.compile(context: ctxt, process: proc) else {
			return false
		}

		defineFunctions(context: ctxt, process: proc)
		defineClassObjects(context: ctxt)
		defineObjects(context: ctxt)
		defineConstructors(context: ctxt)

		return true
	}

	private func defineFunctions(context ctxt: KEContext, process proc: KEProcess) {
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

		/* exit */
		let exitFunc: @convention(block) (_ value: JSValue) -> JSValue
		switch config.kind {
		case .Terminal:
			exitFunc = {
				(_ value: JSValue) -> JSValue in
				let ecode: Int32
				if value.isNumber {
					ecode = value.toInt32()
				} else {
					NSLog("[Error] Invalid parameter for exit() function")
					ecode = 1
				}
				Darwin.exit(ecode)
			}
		case .Window:
			#if os(OSX)
				exitFunc = {
					(_ value: JSValue) -> JSValue in
					NSApplication.shared.terminate(self)
					return JSValue(undefinedIn: ctxt)
				}
			#else
				exitFunc = {
					(_ value: JSValue) -> JSValue in
					return JSValue(undefinedIn: ctxt)
				}
			#endif
		case .Operation:
			exitFunc = {
				(_ value: JSValue) -> JSValue in
				proc.isCanceled = true
				return JSValue(undefinedIn: ctxt)
			}
		}
		ctxt.set(name: "exit", function: exitFunc)
	}

	private func defineClassObjects(context ctxt: KEContext) {
		switch config.kind {
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
		case .Operation:
			break
		case .Window:
			break
		}

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
		let consobj = KLConsole(context: ctxt, console: console)
		ctxt.set(name: "console", object: consobj)
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

