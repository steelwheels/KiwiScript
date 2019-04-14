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
	open override func compile(context ctxt: KEContext, console cons: CNConsole, config conf: KEConfig) -> Bool {
		guard super.compile(context: ctxt, console: cons, config: conf) else {
			cons.error(string: "Failed to compile")
			return false
		}

		defineConstants(context: ctxt)
		defineFunctions(context: ctxt, console: cons, config: conf)
		definePrimitiveObjects(context: ctxt, console: cons, config: conf)
		defineClassObjects(context: ctxt, console: cons, config: conf)
		defineGlobalObjects(context: ctxt, console: cons, config: conf)
		defineConstructors(context: ctxt, console: cons, config: conf)
		importBuiltinLibrary(context: ctxt, console: cons, config: conf)

		return true
	}

	private func defineConstants(context ctxt: KEContext) {
		/* PI */
		if let pival = JSValue(double: Double.pi, in: ctxt){
			ctxt.set(name: "PI", value: pival)
		}
	}

	private func defineFunctions(context ctxt: KEContext, console cons: CNConsole, config conf: KEConfig) {
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

		/* sin */
		let sinFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			if value.isNumber {
				let result = sin(value.toDouble())
				return JSValue(double: result, in: ctxt)
			}
			cons.error(string: "Invalid parameter for sin function\n")
			return JSValue(undefinedIn: ctxt)
		}
		ctxt.set(name: "sin", function: sinFunc)

		/* cos */
		let cosFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			if value.isNumber {
				let result = cos(value.toDouble())
				return JSValue(double: result, in: ctxt)
			}
			cons.error(string: "Invalid parameter for cos function\n")
			return JSValue(undefinedIn: ctxt)
		}
		ctxt.set(name: "cos", function: cosFunc)

		/* tan */
		let tanFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			if value.isNumber {
				let result = tan(value.toDouble())
				return JSValue(double: result, in: ctxt)
			}
			cons.error(string: "Invalid parameter for tan function\n")
			return JSValue(undefinedIn: ctxt)
		}
		ctxt.set(name: "tan", function: tanFunc)

		/* atan2 */
		let atan2Func: @convention(block) (_ yval: JSValue, _ xval: JSValue) -> JSValue = {
			(_ yval: JSValue, _ xval: JSValue) -> JSValue in
			if yval.isNumber && xval.isNumber {
				let result = atan2(yval.toDouble(), xval.toDouble())
				return JSValue(double: result, in: ctxt)
			}
			cons.error(string: "Invalid parameter for atan2 function\n")
			return JSValue(undefinedIn: ctxt)
		}
		ctxt.set(name: "atan2", function: atan2Func)

		/* exit */
		let exitFunc: @convention(block) (_ value: JSValue) -> JSValue
		switch conf.kind {
		case .Terminal:
			exitFunc = {
				(_ value: JSValue) -> JSValue in
				let ecode: Int32
				if value.isNumber {
					ecode = value.toInt32()
				} else {
					cons.error(string: "Invalid parameter for exit() function")
					ecode = 1
				}
				Darwin.exit(ecode)
			}
			ctxt.set(name: "exit", function: exitFunc)
		case .Window:
			#if os(OSX)
				exitFunc = {
					[weak self] (_ value: JSValue) -> JSValue in
					if let myself = self {
						NSApplication.shared.terminate(myself)
					}
					return JSValue(undefinedIn: ctxt)
				}
			#else
				exitFunc = {
					(_ value: JSValue) -> JSValue in
					return JSValue(undefinedIn: ctxt)
				}
			#endif
			ctxt.set(name: "exit", function: exitFunc)
		case .Operation:
			/* The exit function is defined in KLOperation.swift */
			break
		}
	}

	private func definePrimitiveObjects(context ctxt: KEContext, console cons: CNConsole, config conf: KEConfig) {
		/* Point */
		let pointFunc: @convention(block) (_ xval: JSValue, _ yval: JSValue) -> JSValue = {
			(_ xval: JSValue, _ yval: JSValue) -> JSValue in
			if xval.isNumber && yval.isNumber {
				let x = xval.toDouble()
				let y = yval.toDouble()
				return JSValue(point: CGPoint(x: x, y: y), in: ctxt)
			}
			cons.error(string: "Invalid parameter for Point constructor\n")
			return JSValue(undefinedIn: ctxt)
		}
		ctxt.set(name: "Point", function: pointFunc)

		/* Size */
		let sizeFunc: @convention(block) (_ wval: JSValue, _ hval: JSValue) -> JSValue = {
			(_ wval: JSValue, _ hval: JSValue) -> JSValue in
			if wval.isNumber && hval.isNumber {
				let width  = wval.toDouble()
				let height = hval.toDouble()
				return JSValue(size: CGSize(width: width, height: height), in: ctxt)
			}
			cons.error(string: "Invalid parameter for Size constructor\n")
			return JSValue(undefinedIn: ctxt)
		}
		ctxt.set(name: "Size", function: sizeFunc)
	}

	private func defineClassObjects(context ctxt: KEContext, console cons: CNConsole, config conf: KEConfig) {
		switch conf.kind {
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

				let cursesobj = KLCurses(context: ctxt, console: cons)
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
			let shellobj = KLShell(context: ctxt, console: cons)
			ctxt.set(name: "Shell", object: shellobj)
		#endif
	}

	private func defineGlobalObjects(context ctxt: KEContext, console cons: CNConsole, config conf: KEConfig) {
		/* console */
		switch conf.kind {
		case .Terminal, .Operation:
			/* Define console */
			let newcons = KLConsole(context: ctxt, console: cons)
			ctxt.set(name: "console", object: newcons)
		case .Window:
			break
		}
	}

	private func defineConstructors(context ctxt: KEContext, console cons: CNConsole, config conf: KEConfig) {
		/* URL */
		let urlFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			if let str = value.toString() {
				if let url = URL(string: str) {
					return JSValue(URL: url, in: ctxt)
				}
			}
			cons.error(string: "Invalid parameter for URL()")
			return JSValue(nullIn: ctxt)
		}
		ctxt.set(name: "URL", function: urlFunc)

		/* Operaion */
		let opfunc: @convention(block) () -> JSValue = {
			() -> JSValue in
			let opconsole = KLCompiler.currentConsole(context: ctxt, console: cons)
			let opconfig  = KEConfig(kind: .Terminal, doStrict: conf.doStrict, doVerbose: conf.doVerbose)
			let op        = KLOperation(ownerContext: ctxt, console: opconsole, config: opconfig)
			return JSValue(object: op, in: ctxt)
		}
		ctxt.set(name: "Operation", function: opfunc)

		/* OperaionQueue */
		let queuefunc: @convention(block) () -> JSValue = {
			() -> JSValue in
			let curcons = KLCompiler.currentConsole(context: ctxt, console: cons)
			let queue   = KLOperationQueue(context: ctxt, console: curcons)
			return JSValue(object: queue, in: ctxt)
		}
		ctxt.set(name: "OperationQueue", function: queuefunc)
	}

	private func importBuiltinLibrary(context ctxt: KEContext, console cons: CNConsole, config conf: KEConfig)
	{
		/* Get built-in scripts: Math.js */
		if let scr = readResource(fileName: "Math", fileExtension: "js", forClass: KLCompiler.self) {
			let _ = compile(context: ctxt, statement: scr, console: cons, config: conf)
		} else {
			cons.error(string: "Failed to find file: Math.js\n")
		}

		/* Get built-in scripts: Debug.js */
		if let scr = readResource(fileName: "Debug", fileExtension: "js", forClass: KLCompiler.self) {
			let _ = compile(context: ctxt, statement: scr, console: cons, config: conf)
		} else {
			cons.error(string: "Failed to find file: Debug.js\n")
		}
	}

	private class func currentConsole(context ctxt: KEContext, console logcons: CNConsole) -> CNConsole {
		if let consval = ctxt.getValue(name: "console") {
			if consval.isObject {
				if let consobj = consval.toObject() as? KLConsole {
					return consobj.console
				}
			}
		}
		logcons.error(string: "Failed to find \"console\" object. Use default console\n")
		return CNDefaultConsole()
	}
}

