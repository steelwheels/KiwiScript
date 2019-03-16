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
	public var	libConfig: KLConfig

	public init(console cons: CNConsole, config conf: KLConfig) {
		libConfig = conf
		super.init(console: cons, config: conf)
	}

	open override func compile(context ctxt: KEContext) -> Bool {
		guard super.compile(context: ctxt) else {
			return false
		}

		defineFunctions(context: ctxt)
		definePrimitiveObjects(context: ctxt)
		defineClassObjects(context: ctxt)
		defineGlobalObjects(context: ctxt)
		defineConstructors(context: ctxt)
		importLibrary(context: ctxt)

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

		/* sin */
		let sinFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			if value.isNumber {
				let result = sin(value.toDouble())
				return JSValue(double: result, in: ctxt)
			}
			self.console.error(string: "Invalid parameter for sin function\n")
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
			self.console.error(string: "Invalid parameter for cos function\n")
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
			self.console.error(string: "Invalid parameter for tan function\n")
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
			self.console.error(string: "Invalid parameter for atan2 function\n")
			return JSValue(undefinedIn: ctxt)
		}
		ctxt.set(name: "atan2", function: atan2Func)

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
					CNLog(type: .Error, message: "Invalid parameter for exit() function", file: #file, line: #line, function: #function)
					ecode = 1
				}
				Darwin.exit(ecode)
			}
			ctxt.set(name: "exit", function: exitFunc)
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
			ctxt.set(name: "exit", function: exitFunc)
		case .Operation:
			/* The exit function is defined in KLOperation.swift */
			break
		}
	}

	private func definePrimitiveObjects(context ctxt: KEContext) {
		/* Point */
		let pointFunc: @convention(block) (_ xval: JSValue, _ yval: JSValue) -> JSValue = {
			(_ xval: JSValue, _ yval: JSValue) -> JSValue in
			if xval.isNumber && yval.isNumber {
				let x = xval.toDouble()
				let y = yval.toDouble()
				return JSValue(point: CGPoint(x: x, y: y), in: ctxt)
			}
			self.console.error(string: "Invalid parameter for Point constructor\n")
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
			self.console.error(string: "Invalid parameter for Size constructor\n")
			return JSValue(undefinedIn: ctxt)
		}
		ctxt.set(name: "Size", function: sizeFunc)
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

	private func defineGlobalObjects(context ctxt: KEContext) {
		/* console */
		switch config.kind {
		case .Terminal, .Operation:
			/* Define console */
			let newcons = KLConsole(context: ctxt, console: console)
			ctxt.set(name: "console", object: newcons)
		case .Window:
			break
		}
	}

	private func defineConstructors(context ctxt: KEContext) {
		/* URL */
		let urlFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			if let str = value.toString() {
				let urlobj = KLURL(URL: URL(string: str), context: ctxt)
				return JSValue(object: urlobj, in: ctxt)
			} else {
				self.console.error(string: "Invalid parameter for URL constructor\n")
				return JSValue(undefinedIn: ctxt)
			}
		}
		ctxt.set(name: "URL", function: urlFunc)

		/* Operaion */
		let opfunc: @convention(block) (_ param: JSValue) -> JSValue = {
			(_ param: JSValue) -> JSValue in
			//CNLog(type: .Flow, message: "Allocate Operation method", file: #file, line: #line, function: #function)
			let conf = KLConfig(kind: .Operation, doStrict: true, doVerbose: self.config.doVerbose)
			let op   = KLOperation(ownerContext: ctxt, console: self.console, config: conf)
			if !param.isUndefined {
				op.parameter = param
			}
			return JSValue(object: op, in: ctxt)
		}
		ctxt.set(name: "Operation", function: opfunc)

		/* OperaionQueue */
		let queuefunc: @convention(block) () -> JSValue = {
			() -> JSValue in
			let queue = KLOperationQueue(console: self.console)
			return JSValue(object: queue, in: ctxt)
		}
		ctxt.set(name: "OperationQueue", function: queuefunc)
	}

	private func importLibrary(context ctxt: KEContext) {
		if libConfig.doUseGraphicsPrimitive {
			if let script = readResource(fileName: "Library/graphics", fileExtension: "js", forClass: KLCompiler.self) {
				let _ = compile(context: ctxt, statement: script)
			}
		}
	}
}

