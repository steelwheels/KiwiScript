/**
 * @file	KLCompiler.swift
 * @brief	Define KLCompiler class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import CoconutDatabase
import JavaScriptCore
#if os(OSX)
import AppKit
#else
import UIKit
#endif
import Foundation

public class KLLibraryCompiler: KECompiler
{
	public func compile(context ctxt: KEContext, resource res: KEResource, processManager procmgr: CNProcessManager, terminalInfo terminfo: CNTerminalInfo, environment env: CNEnvironment, console cons: CNFileConsole, config conf: KEConfig) -> Bool {
		guard compileBase(context: ctxt, terminalInfo: terminfo, environment: env, console: cons, config: conf) else {
			CNLog(logLevel: .error, message: "[Error] Failed to compile: base", atFunction: #function, inFile: #file)
			return false
		}
		guard compileGeneralFunctions(context: ctxt, resource: res, processManager: procmgr, terminalInfo: terminfo, environment: env, console: cons, config: conf) else {
			CNLog(logLevel: .error, message: "[Error] Failed to compile: general functions", atFunction: #function, inFile: #file)
			return false
		}
		guard compileThreadFunctions(context: ctxt, resource: res, processManager: procmgr, terminalInfo: terminfo, environment: env, console: cons, config: conf) else {
			CNLog(logLevel: .error, message: "[Error] Failed to compile: thread functions", atFunction: #function, inFile: #file)
			return false
		}
		guard compileBuiltinScripts(context: ctxt, terminalInfo: terminfo, environment: env, console: cons, config: conf) else {
			CNLog(logLevel: .error, message: "[Error] Failed to compile: built-in scripts", atFunction: #function, inFile: #file)
			return false
		}
		guard compileUserScripts(context: ctxt, resource: res, processManager: procmgr, environment: env, console: cons, config: conf) else {
			CNLog(logLevel: .error, message: "[Error] Failed to compile: user scripts", atFunction: #function, inFile: #file)
			return false
		}
		return true
	}

	private func compileGeneralFunctions(context ctxt: KEContext, resource res: KEResource, processManager procmgr: CNProcessManager, terminalInfo terminfo: CNTerminalInfo, environment env: CNEnvironment, console cons: CNFileConsole, config conf: KEConfig) -> Bool {
		defineConstants(context: ctxt)
		defineFunctions(context: ctxt, console: cons, config: conf)
		definePrimitiveObjects(context: ctxt, console: cons, config: conf)
		defineClassObjects(context: ctxt, terminalInfo: terminfo, environment: env, console: cons, config: conf)
		defineGlobalObjects(context: ctxt, console: cons, config: conf)
		defineConstructors(context: ctxt, resource: res, console: cons, config: conf)
		defineDatabase(context: ctxt, console: cons, config: conf)
		return true
	}

	private func compileThreadFunctions(context ctxt: KEContext, resource res: KEResource, processManager procmgr: CNProcessManager, terminalInfo terminfo: CNTerminalInfo, environment env: CNEnvironment, console cons: CNConsole, config conf: KEConfig) -> Bool {
		if defineThreadFunction(context: ctxt, resource: res, processManager: procmgr, terminalInfo: terminfo, environment: env, console: cons, config: conf) {
			return (ctxt.errorCount == 0)
		} else {
			return false
		}
	}

	private func compileBuiltinScripts(context ctxt: KEContext, terminalInfo terminfo: CNTerminalInfo, environment env: CNEnvironment, console cons: CNFileConsole, config conf: KEConfig) -> Bool {
		importBuiltinLibrary(context: ctxt, console: cons, config: conf)
		return (ctxt.errorCount == 0)
	}

	private func compileUserScripts(context ctxt: KEContext, resource res: KEResource, processManager procmgr: CNProcessManager, environment env: CNEnvironment, console cons: CNConsole, config conf: KEConfig) -> Bool {
		if compileLibraryFiles(context: ctxt, resource: res, processManager: procmgr, environment: env, console: cons, config: conf) {
			return (ctxt.errorCount == 0)
		} else {
			return false
		}
	}

	private func compileLibraryFiles(context ctxt: KEContext, resource res: KEResource, processManager procmgr: CNProcessManager, environment env: CNEnvironment, console cons: CNConsole, config conf: KEConfig) -> Bool {
		/* Compile library */
		var result = true
		if let libnum = res.countOfLibraries() {
			for i in 0..<libnum {
				if let scr = res.loadLibrary(index: i) {
					let _ = self.compileStatement(context: ctxt, statement: scr, console: cons, config: conf)
				} else {
					if let fname = res.URLOfLibrary(index: i) {
						cons.error(string: "Failed to load library: \(fname.absoluteString)\n")
						result = false
					} else {
						cons.error(string: "Failed to load file in library section\n")
						result = false
					}
				}
			}
		}
		return result && (ctxt.errorCount == 0)
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

		/* toBoolean */
		let toBooleanFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			if value.isBoolean {
				return value
			} else if value.isNumber {
				if let num = value.toNumber() {
					return JSValue(bool: num.intValue != 0, in: ctxt)
				} else {
					return JSValue(nullIn: ctxt)
				}
			} else {
				return JSValue(nullIn: ctxt)
			}
		}
		ctxt.set(name: "toBoolean", function: toBooleanFunc)

		/* isNumber */
		let isNumberFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			let result: Bool = value.isNumber
			return JSValue(bool: result, in: ctxt)
		}
		ctxt.set(name: "isNumber", function: isNumberFunc)

		/* toNumber */
		let toNumberFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			if value.isNumber {
				return value
			} else {
				return JSValue(nullIn: ctxt)
			}
		}
		ctxt.set(name: "toNumber", function: toNumberFunc)

		/* isString */
		let isStringFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			let result: Bool = value.isString
			return JSValue(bool: result, in: ctxt)
		}
		ctxt.set(name: "isString", function: isStringFunc)

		/* toString */
		let toStringFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			if value.isString {
				return value
			} else {
				return JSValue(nullIn: ctxt)
			}
		}
		ctxt.set(name: "toString", function: toStringFunc)

		/* isObject */
		let isObjectFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			let result: Bool = value.isObject
			return JSValue(bool: result, in: ctxt)
		}
		ctxt.set(name: "isObject", function: isObjectFunc)

		/* toObject */
		let toObjectFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			if value.isObject {
				return value
			} else {
				return JSValue(nullIn: ctxt)
			}
		}
		ctxt.set(name: "toObject", function: toObjectFunc)

		/* isArray */
		let isArrayFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			let result: Bool = value.isArray
			return JSValue(bool: result, in: ctxt)
		}
		ctxt.set(name: "isArray", function: isArrayFunc)

		/* toArray */
		let toArrayFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			if value.isArray {
				return value
			} else {
				return JSValue(nullIn: ctxt)
			}
		}
		ctxt.set(name: "toArray", function: toArrayFunc)

		/* isDictionary */
		let isDictFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			var result: Bool = false
			if value.isObject {
				if let _ = value.toObject() as? Dictionary<String, Any> {
					result = true
				}
			}
			return JSValue(bool: result, in: ctxt)
		}
		ctxt.set(name: "isDictionary", function: isDictFunc)

		/* toDictionary */
		let toDictFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			if value.isObject {
				if let _ = value.toObject() as? Dictionary<String, Any> {
					return value
				}
			}
			return JSValue(nullIn: ctxt)
		}
		ctxt.set(name: "toDictionary", function: toDictFunc)

		/* isRecord */
		let isRecordFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			return JSValue(bool: value.isRecord, in: ctxt)
		}
		ctxt.set(name: "isRecord", function: isRecordFunc)

		/* toRecord */
		let toRecordFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			if value.isRecord {
				return value
			} else {
				return JSValue(nullIn: ctxt)
			}
		}
		ctxt.set(name: "toRecord", function: toRecordFunc)

		/* isDate */
		let isDateFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			let result: Bool = value.isDate
			return JSValue(bool: result, in: ctxt)
		}
		ctxt.set(name: "isDate", function: isDateFunc)

		/* toDate */
		let toDateFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			if value.isDate {
				return value
			} else {
				return JSValue(nullIn: ctxt)
			}
		}
		ctxt.set(name: "toDate", function: toDateFunc)

		/* isURL */
		let isURLFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			let result: Bool = value.isURL
			return JSValue(bool: result, in: ctxt)
		}
		ctxt.set(name: "isURL", function: isURLFunc)

		/* toURL */
		let toURLFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			if value.isURL {
				return value
			} else {
				return JSValue(nullIn: ctxt)
			}
		}
		ctxt.set(name: "toURL", function: toURLFunc)

		/* isPoint */
		let isPointFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			return JSValue(bool: value.isPoint, in: ctxt)
		}
		ctxt.set(name: "isPoint", function: isPointFunc)

		let toPointFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			if value.isPoint {
				return value
			} else {
				return JSValue(nullIn: ctxt)
			}
		}
		ctxt.set(name: "toPoint", function: toPointFunc)

		/* isSize */
		let isSizeFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			let result: Bool = value.isSize
			return JSValue(bool: result, in: ctxt)
		}
		ctxt.set(name: "isSize", function: isSizeFunc)

		/* toSize */
		let toSizeFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			if value.isSize {
				return value
			} else {
				return JSValue(nullIn: ctxt)
			}
		}
		ctxt.set(name: "toSize", function: toSizeFunc)

		/* isRect */
		let isRectFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			let result: Bool = value.isRect
			return JSValue(bool: result, in: ctxt)
		}
		ctxt.set(name: "isRect", function: isRectFunc)

		/* toRect */
		let toRectFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			if value.isRect {
				return value
			} else {
				return JSValue(nullIn: ctxt)
			}
		}
		ctxt.set(name: "toRect", function: toRectFunc)

		/* isBitmap */
		let isBitmapFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			let result: Bool = value.isBitmap
			return JSValue(bool: result, in: ctxt)
		}
		ctxt.set(name: "isBitmap", function: isBitmapFunc)

		/* toBitmap */
		let toBitmapFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			if value.isBitmap {
				return value
			} else {
				return JSValue(nullIn: ctxt)
			}
		}
		ctxt.set(name: "toBitmap", function: toBitmapFunc)

		/* toText */
		let toTextFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			let result: KLTextProtocol
			let txt = value.toText()
			if let line = txt as? CNTextLine {
				result = KLTextLine(text: line, context: ctxt)
			} else if let sect = txt as? CNTextSection {
				result = KLTextSection(text: sect, context: ctxt)
			} else if let table = txt as? CNTextTable {
				result = KLTextTable(text: table, context: ctxt)
			} else {
				let line = CNTextLine(string: "\(value)")
				result = KLTextLine(text: line, context: ctxt)
			}
			return JSValue(object: result, in: ctxt)
		}
		ctxt.set(name: "toText", function: toTextFunc)

		/* isEOF */
		let isEofFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			var result = false
			if value.isNumber {
				if let num = value.toNumber() {
					if num.int32Value == CNFile.EOF {
						result = true
					}
				}
			}
			return JSValue(bool: result, in: ctxt)
		}
		ctxt.set(name: "isEOF", function: isEofFunc)

		/* typeID */
		let valtypeFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			if let type = value.type {
				return JSValue(int32: Int32(type.rawValue), in: ctxt)
			} else {
				return JSValue(undefinedIn: ctxt)
			}
		}
		ctxt.set(name: "valueType", function: valtypeFunc)

		/* asciiCodeName */
		let asciiNameFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			if value.isNumber {
				let code = value.toInt32()
				if let name = Character.asciiCodeName(code: Int(code)) {
					return JSValue(object: name, in: ctxt)
				}
			}
			return JSValue(nullIn: ctxt)
		}
		ctxt.set(name: "asciiCodeName", function: asciiNameFunc)

		/* sleep */
		let sleepFunc: @convention(block) (_ val: JSValue) -> JSValue = {
			(_ val: JSValue) -> JSValue in
			let result: Bool
			if val.isNumber {
				Thread.sleep(forTimeInterval: val.toDouble())
				result = true
			} else {
				result = false
			}
			return JSValue(bool: result, in: ctxt)
		}
		ctxt.set(name: "sleep", function: sleepFunc)

		/* _openPanel */

		let openPanelFunc: @convention(block) (_ titleval: JSValue, _ typeval: JSValue, _ extsval: JSValue, _ cbfunc: JSValue) -> Void = {
			(_ titleval: JSValue, _ typeval: JSValue, _ extsval: JSValue, _ cbfunc: JSValue) -> Void in
			#if os(OSX)
			if let title = KLLibraryCompiler.valueToString(value: titleval),
			   let type  = KLLibraryCompiler.valueToFileType(type: typeval),
			   let exts  = KLLibraryCompiler.valueToExtensions(extensions: extsval) {
				URL.openPanel(title: title, type: type, extensions: exts, callback: {
					(_ urlp: URL?) -> Void in
					let param: JSValue
					if let url = urlp {
						param = JSValue(URL: url, in: ctxt)
					} else {
						param = JSValue(nullIn: ctxt)
					}
					CNExecuteInUserThread(level: .event, execute: {
						cbfunc.call(withArguments: [param])
					})
				})
			} else {
				if let param = JSValue(nullIn: ctxt) {
					cbfunc.call(withArguments: [param])
				} else {
					CNLog(logLevel: .error, message: "Failed to allocate return value", atFunction: #function, inFile: #file)
				}
			}
			#else
			if let param = JSValue(nullIn: ctxt) {
				cbfunc.call(withArguments: [param])
			} else {
				CNLog(logLevel: .error, message: "Failed to allocate return value", atFunction: #function, inFile: #file)
			}
			#endif
		}
		ctxt.set(name: "_openPanel", function: openPanelFunc)

		let savePanelFunc: @convention(block) (_ titleval: JSValue, _ cbfunc: JSValue) -> Void = {
			(_ titleval: JSValue, _ cbfunc: JSValue) -> Void in
			#if os(OSX)
			if let title = KLLibraryCompiler.valueToString(value: titleval) {
				URL.savePanel(title: title, outputDirectory: nil, callback: {
					(_ urlp: URL?) -> Void in
					let param: JSValue
					if let url = urlp {
						param = JSValue(URL: url, in: ctxt)
					} else {
						param = JSValue(nullIn: ctxt)
					}
					cbfunc.call(withArguments: [param])
				})
			} else {
				if let param = JSValue(nullIn: ctxt) {
					cbfunc.call(withArguments: [param])
				} else {
					CNLog(logLevel: .error, message: "Failed to allocate return value", atFunction: #function, inFile: #file)
				}
			}
			#else
			if let param = JSValue(nullIn: ctxt) {
				cbfunc.call(withArguments: [param])
			} else {
				CNLog(logLevel: .error, message: "Failed to allocate return value", atFunction: #function, inFile: #file)
			}
			#endif
		}
		ctxt.set(name: "_savePanel", function: savePanelFunc)

		/* exit */
		let exitFunc: @convention(block) (_ value: JSValue) -> JSValue
		switch conf.applicationType {
		case .terminal:
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
		case .window:
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
		@unknown default:
			CNLog(logLevel: .error, message: "Unknown application type", atFunction: #function, inFile: #file)
			break
		}

		/* _select_exit_code */
		let selExitFunc: @convention(block) (_ val0: JSValue, _ val1: JSValue) -> JSValue = {
			(_ val0: JSValue, _ val1: JSValue) -> JSValue in
			let result: Int32
			if val0.isNumber && val1.isNumber {
				let code0 = val0.toInt32()
				let code1 = val1.toInt32()
				if code0 != 0 {
					result = code0
				} else if code1 != 0 {
					result = code1
				} else {
					result = 0
				}
			} else {
				CNLog(logLevel: .error, message: "Invalid parameter for exit() function")
				result = -1
			}
			return JSValue(int32: result, in: ctxt)
		}
		ctxt.set(name: "_select_exit_code", function: selExitFunc)
	}

	private func definePrimitiveObjects(context ctxt: KEContext, console cons: CNConsole, config conf: KEConfig) {
		/* Point */
		let pointFunc: @convention(block) (_ xval: JSValue, _ yval: JSValue) -> JSValue = {
			(_ xval: JSValue, _ yval: JSValue) -> JSValue in
			if xval.isNumber && yval.isNumber {
				let x = xval.toDouble()
				let y = yval.toDouble()
				return CGPoint(x: x, y: y).toJSValue(context: ctxt)
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
				return CGSize(width: width, height: height).toJSValue(context: ctxt)
			}
			cons.error(string: "Invalid parameter for Size constructor\n")
			return JSValue(undefinedIn: ctxt)
		}
		ctxt.set(name: "Size", function: sizeFunc)


		/* Rect */
		let rectFunc: @convention(block) (_ xval: JSValue, _ yval: JSValue, _ widthval: JSValue, _ heightval: JSValue) -> JSValue = {
			(_ xval: JSValue, _ yval: JSValue, _ widthval: JSValue, _ heightval: JSValue) -> JSValue in
			if xval.isNumber && yval.isNumber && widthval.isNumber && heightval.isNumber {
				let x	   = xval.toDouble()
				let y	   = yval.toDouble()
				let width  = widthval.toDouble()
				let height = heightval.toDouble()
				let rect   = CGRect(x: x, y: y, width: width, height: height)
				return rect.toJSValue(context: ctxt)
			} else if xval.isPoint && yval.isSize {
				let org  = xval.toPoint()
				let size = yval.toSize()
				let rect = CGRect(origin: org, size: size)
				return rect.toJSValue(context: ctxt)
			}
			cons.error(string: "Invalid parameter for Rect constructor\n")
			return JSValue(undefinedIn: ctxt)
		}
		ctxt.set(name: "Rect", function: rectFunc)
	}

	private func defineClassObjects(context ctxt: KEContext, terminalInfo terminfo: CNTerminalInfo, environment env: CNEnvironment, console cons: CNFileConsole, config conf: KEConfig) {
		/* Pipe() */
		let pipeFunc:  @convention(block) () -> JSValue = {
			() -> JSValue in
			let pipe = KLPipe(context: ctxt)
			return JSValue(object: pipe, in: ctxt)
		}
		ctxt.set(name: "Pipe", function: pipeFunc)

		/* File */
		let file = KLFileManager(context: 	ctxt,
					 environment:	env,
					 input:   	cons.inputFile,
					 output:  	cons.outputFile,
					 error:   	cons.errorFile)
		ctxt.set(name: "FileManager", object: file)

		let stdin = KLFile(file: cons.inputFile, context: ctxt)
		ctxt.set(name: KLFile.StdInName, object: stdin)

		let stdout = KLFile(file: cons.outputFile, context: ctxt)
		ctxt.set(name: KLFile.StdOutName, object: stdout)

		let stderr = KLFile(file: cons.errorFile, context: ctxt)
		ctxt.set(name: KLFile.StdErrName, object: stderr)

		/* Color manager */
		let colmgr = KLColorManager(context: ctxt)
		ctxt.set(name: "Color", object: colmgr)

		/* Curses */
		let curses = KLCurses(console: cons, terminalInfo: terminfo, context: ctxt)
		ctxt.set(name: "Curses", object: curses)

		/* FontManager */
		let fontmgr = KLFontManager(context: ctxt)
		ctxt.set(name: "FontManager", object: fontmgr)

		/* ValueFile */
		let native = KLNativeValueFile(context: ctxt)
		ctxt.set(name: "_JSONFile", object: native)

		/* Char */
		let charobj = KLChar(context: ctxt)
		ctxt.set(name: "Char", object: charobj)

		/* EscapeCode */
		let ecode = KLEscapeCode(context: ctxt)
		ctxt.set(name: "EscapeCode", object: ecode)

		/* Environment */
		let envobj = KLEnvironment(environment: env, context: ctxt)
		ctxt.set(name: "Environment", object: envobj)

		/* Preference: This value will be override by KiwiShell */
		let pref = KLPreference(context: ctxt)
		ctxt.set(name: "Preference", object: pref)

		/* Built-in script manager */
		let scrmgr = KLBuiltinScriptManager(context: ctxt)
		ctxt.set(name: "ScriptManager", object: scrmgr)

		/* Symbols */
		let symbol = KLSymbol(context: ctxt)
		ctxt.set(name: "Symbols", object: symbol)
	}

	private func defineGlobalObjects(context ctxt: KEContext, console cons: CNFileConsole, config conf: KEConfig) {
		/* console */
		let newcons = KLConsole(context: ctxt, console: cons)
		ctxt.set(name: "console", object: newcons)
	}

	private func defineConstructors(context ctxt: KEContext, resource res: KEResource, console cons: CNConsole, config conf: KEConfig) {
		/* URL */
		let urlFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			if let str = value.toString() {
				let url: URL?
				if let _ = FileManager.default.schemeInPath(pathString: str) {
					url = URL(string: str)
				} else {
					url = URL(fileURLWithPath: str)
				}
				if let u = url {
					return JSValue(URL: u, in: ctxt)
				}
			}
			cons.error(string: "Invalid parameter for URL: \(value.description)")
			return JSValue(nullIn: ctxt)
		}
		ctxt.set(name: "URL", function: urlFunc)

		/* Bitmap */
		let allocBitmapFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			var result: KLBitmapData? = nil
			if value.isBitmap {
				result = value.toBitmap()
			} else if value.isObject {
				if let arr = value.toObject() as? Array<Array<KLColor>> {
					let carr = arr.map { $0.map { $0.core } }
					let bm   = CNBitmapData(colorData: carr)
					result = KLBitmapData(bitmap: bm, context: ctxt)
				}
			}
			if let r = result {
				return JSValue(object: r, in: ctxt)
			} else {
				return JSValue(nullIn: ctxt)
			}
		}
		ctxt.set(name: "Bitmap", function: allocBitmapFunc)

		/* Lock */
		/*
		let allocLockFunc: @convention(block) () -> JSValue = {
			() -> JSValue in
			return JSValue(object: KLLock(), in: ctxt)
		}
		ctxt.set(name: "Lock", function: allocLockFunc)*/

		/* Dictionary */
		let allocDictFunc: @convention(block) (_ param: JSValue) -> JSValue = {
			(_ param: JSValue) -> JSValue in
			let result: JSValue
			if param.isDictionary {
				if let dict = param.toDictionary() as? Dictionary<String, Any> {
					let dict = KLDictionary(value: dict, context: ctxt)
					result = JSValue(object: dict, in: ctxt)
				} else {
					CNLog(logLevel: .error, message: "Failed to decode parameter", atFunction: #function, inFile: #file)
					result = JSValue(nullIn: ctxt)
				}
			} else {
				let dict = KLDictionary(context: ctxt)
				result = JSValue(object: dict, in: ctxt)
			}
			return result
		}
		ctxt.set(name: "Dictionary", function: allocDictFunc)

		/* Table */
		let allocTableFunc: @convention(block) (_ pathval: JSValue, _ storageval: JSValue) -> JSValue = {
			(_ pathval: JSValue, _ storageval: JSValue) -> JSValue in
			if pathval.isString && storageval.isObject {
				if let pathstr = pathval.toString(),
				   let storage = storageval.toObject() as? KLStorage {
					switch CNValuePath.pathExpression(string: pathstr) {
					case .success(let path):
						let table  = CNStorageTable(path: path, storage: storage.core())
						let tblobj = KLTable(table: table, context: ctxt)
						return JSValue(object: tblobj, in: ctxt)
					case .failure(let err):
						CNLog(logLevel: .error, message: err.toString(), atFunction: #function, inFile: #file)
					}
				}
			}
			return JSValue(nullIn: ctxt)
		}
		ctxt.set(name: "Table", function: allocTableFunc)

		/* Storage */
		let allocStorageFunc: @convention(block) (_ nameval: JSValue) -> JSValue = {
			(_ nameval: JSValue) -> JSValue in
			var result: KLStorage? = nil
			if nameval.isString {
				if let name = nameval.toString() {
					if let storage = res.loadStorage(identifier: name) {
						result = KLStorage(storage: storage, context: ctxt)
					}
				}
			}
			if let obj = result {
				return JSValue(object: obj, in: ctxt)
			} else {
				return JSValue(nullIn: ctxt)
			}
		}
		ctxt.set(name: "Storage", function: allocStorageFunc)

		/* TextLine */
		let textLineFunc: @convention(block) (_ str: JSValue) -> JSValue = {
			(_ str: JSValue) -> JSValue in
			let txt = CNTextLine(string: str.toString())
			return JSValue(object: KLTextLine(text: txt, context: ctxt), in: ctxt)
		}
		ctxt.set(name: "TextLine", function: textLineFunc)

		/* TextSection */
		let textSectionFunc: @convention(block) () -> JSValue = {
			() -> JSValue in
			let txt = CNTextSection()
			return JSValue(object: KLTextSection(text: txt, context: ctxt), in: ctxt)
		}
		ctxt.set(name: "TextSection", function: textSectionFunc)

		/* TextRecord */
		let textRecordFunc: @convention(block) () -> JSValue = {
			() -> JSValue in
			let txt = CNTextRecord()
			return JSValue(object: KLTextRecord(text: txt, context: ctxt), in: ctxt)
		}
		ctxt.set(name: "TextRecord", function: textRecordFunc)

		/* TextTable */
		let textTableFunc: @convention(block) () -> JSValue = {
			() -> JSValue in
			let txt = CNTextTable()
			return JSValue(object: KLTextTable(text: txt, context: ctxt), in: ctxt)
		}
		ctxt.set(name: "TextTable", function: textTableFunc)

		/* Collection */
		let collectionFunc: @convention(block) () -> JSValue = {
			() -> JSValue in
			let newcol = CNCollection()
			return JSValue(object: KLCollection(collection: newcol, context: ctxt), in: ctxt)
		}
		ctxt.set(name: "Collection", function: collectionFunc)
	}

	private func importBuiltinLibrary(context ctxt: KEContext, console cons: CNConsole, config conf: KEConfig)
	{
		/* Contacts.js depends on the Process.js */
		let libnames = ["Object", "Array", "Table", "Debug", "File", "Graphics", "Curses", "Math", "Process", "String", "Turtle", "Contacts"]
		do {
			for libname in libnames {
				if let url = CNFilePath.URLForResourceFile(fileName: libname, fileExtension: "js", subdirectory: "Library", forClass: KLLibraryCompiler.self) {
					let script = try String(contentsOf: url, encoding: .utf8)
					let _ = compileStatement(context: ctxt, statement: script, console: cons, config: conf)
				} else {
					cons.error(string: "Built-in script \"\(libname)\" is not found.")
				}
			}
		} catch {
			cons.error(string: "Failed to read built-in script in KiwiLibrary")
		}
	}

	private func defineThreadFunction(context ctxt: KEContext, resource res: KEResource, processManager procmgr: CNProcessManager, terminalInfo terminfo: CNTerminalInfo, environment env: CNEnvironment, console cons: CNConsole, config conf: KEConfig) -> Bool {
		/* Thread */
		let thfunc: @convention(block) (_ pathval: JSValue, _ inval: JSValue, _ outval: JSValue, _ errval: JSValue) -> JSValue = {
			(_ pathval: JSValue, _ inval: JSValue, _ outval: JSValue, _ errval: JSValue) -> JSValue in
			let launcher = KLThreadLauncher(context: ctxt, resource: res, processManager: procmgr, terminalInfo: terminfo, environment: env, config: conf)
			return launcher.run(path: pathval, input: inval, output: outval, error: errval)
		}
		ctxt.set(name: "Thread", function: thfunc)

		/* Run */
		let runfunc: @convention(block) (_ pathval: JSValue, _ inval: JSValue, _ outval: JSValue, _ errval: JSValue) -> JSValue = {
			(_ pathval: JSValue, _ inval: JSValue, _ outval: JSValue, _ errval: JSValue) -> JSValue in
			let launcher = KLThreadLauncher(context: ctxt, resource: res, processManager: procmgr, terminalInfo: terminfo, environment: env, config: conf)
			return launcher.run(path: pathval, input: inval, output: outval, error: errval)
		}
		ctxt.set(name: "_run", function: runfunc)
		return true
	}

	private func defineDatabase(context ctxt: KEContext, console cons: CNConsole, config conf: KEConfig) {
		/* ContactDatabase */
		let contact = KLContactDatabase(context: ctxt)
		ctxt.set(name: "Contacts", object: contact)
	}

	#if os(OSX)
	private enum Application {
	case textEdit
	case safari
	case other
	}

	private func applicationKind(application app: NSRunningApplication) -> Application {
		var result: Application = .other
		if let ident = app.bundleIdentifier {
			switch ident {
			case "com.apple.TextEdit":
				result = .textEdit
			case "com.apple.Safari":
				result = .safari
			default:
				break
			}
		}
		return result
	}

	#endif

	private class func valueToString(value val: JSValue) -> String? {
		if val.isString	{
			return val.toString()
		} else {
			return nil
		}
	}

	private class func valueToURLs(URLvalues urlval: JSValue, console cons: CNConsole) -> Array<URL>? {
		if urlval.isArray {
			var result: Array<URL> = []
			for val in urlval.toArray() {
				if let url = anyToURL(anyValue: val) {
					result.append(url)
				} else {
					let classname = type(of: val)
					cons.error(string: "Failed to get url: \(classname)\n")
					return nil
				}
			}
			return result
		}
		cons.error(string: "Invalid URL parameters\n")
		return nil
	}

	private class func valueToFileType(type tval: JSValue) -> CNFileType? {
		if let num = tval.toNumber() {
			if let sel = CNFileType(rawValue: num.intValue) {
				return sel
			}
		}
		return nil
	}

	private static func valueToExtensions(extensions tval: JSValue) -> Array<String>? {
		if tval.isArray {
			var types: Array<String> = []
			if let vals = tval.toArray() {
				for elm in vals {
					if let str = elm as? String {
						types.append(str)
					} else {
						return nil
					}
				}
			}
			return types
		}
		return nil
	}

	private class func anyToURL(anyValue val: Any) -> URL? {
		var result: URL? = nil
		if let urlobj = val as? KLURL {
			if let url = urlobj.url {
				result = url
			}
		} else if let urlval = val as? JSValue {
			if let urlobj = urlval.toObject() as? KLURL {
				if let url = urlobj.url {
					result = url
				}
			} else if urlval.isString {
				if let str = urlval.toString() {
					result  = URL(fileURLWithPath: str)
				}
			}
		}
		return result
	}

	#if os(OSX)
	private class func anyToProcess(anyValue val: Any) -> KLProcessProtocol? {
		if let proc = val as? KLProcessProtocol {
			return proc
		} else if let procval = val as? JSValue {
			if procval.isObject {
				if let procobj = procval.toObject() {
					return anyToProcess(anyValue: procobj)
				}
			}
		}
		return nil
	}
	#endif
}

