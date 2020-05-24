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
	open override func compileBase(context ctxt: KEContext, terminalInfo terminfo: CNTerminalInfo, environment env: CNEnvironment, console cons: CNFileConsole, config conf: KEConfig) -> Bool {
		/* Expand enum table before they are defined */
		addEnumTypes()

		guard super.compileBase(context: ctxt, terminalInfo: terminfo, environment: env, console: cons, config: conf) else {
			cons.error(string: "Failed to compile")
			return false
		}

		defineConstants(context: ctxt)
		defineFunctions(context: ctxt, console: cons, config: conf)
		definePrimitiveObjects(context: ctxt, console: cons, config: conf)
		defineClassObjects(context: ctxt, terminalInfo: terminfo, environment: env, console: cons, config: conf)
		defineGlobalObjects(context: ctxt, console: cons, config: conf)
		defineConstructors(context: ctxt, console: cons, config: conf)
		importBuiltinLibrary(context: ctxt, console: cons, config: conf)
		defineOperationObjects(context: ctxt, terminalInfo: terminfo, environment: env, console: cons, config: conf)

		return true
	}

	open func compileLibraryInResource(context ctxt: KEContext, processManager procmgr: CNProcessManager, environment env: CNEnvironment, resource res: KEResource, console cons: CNConsole, config conf: KEConfig) -> Bool {
		if super.compileLibraryInResource(context: ctxt, resource: res, console: cons, config: conf) {
			defineThreadFunction(context: ctxt, processManager: procmgr, environment: env, resource: res, console: cons, config: conf)
			return (ctxt.errorCount == 0)
		} else {
			return false
		}
	}

	private func addEnumTypes() {
		let etable = KEEnumTable.shared

		/* Define enum TypeID */
		let typeid = KEEnumType(typeName: "TypeID")
		typeid.add(members: [
			KEEnumType.Member(name: "Undefined",	value: Int32(JSValueType.UndefinedType.rawValue)),
			KEEnumType.Member(name: "Null",		value: Int32(JSValueType.NullType.rawValue)),
			KEEnumType.Member(name: "Boolean",	value: Int32(JSValueType.BooleanType.rawValue)),
			KEEnumType.Member(name: "Number",	value: Int32(JSValueType.NumberType.rawValue)),
			KEEnumType.Member(name: "String",	value: Int32(JSValueType.StringType.rawValue)),
			KEEnumType.Member(name: "Date",		value: Int32(JSValueType.DateType.rawValue)),
			KEEnumType.Member(name: "URL",		value: Int32(JSValueType.URLType.rawValue)),
			KEEnumType.Member(name: "Image",	value: Int32(JSValueType.ImageType.rawValue)),
			KEEnumType.Member(name: "Array",	value: Int32(JSValueType.ArrayType.rawValue)),
			KEEnumType.Member(name: "Dictionary",	value: Int32(JSValueType.DictionaryType.rawValue)),
			KEEnumType.Member(name: "Range",	value: Int32(JSValueType.RangeType.rawValue)),
			KEEnumType.Member(name: "Rect",		value: Int32(JSValueType.RectType.rawValue)),
			KEEnumType.Member(name: "Point",	value: Int32(JSValueType.PointType.rawValue)),
			KEEnumType.Member(name: "Size",		value: Int32(JSValueType.SizeType.rawValue)),
			KEEnumType.Member(name: "Object",	value: Int32(JSValueType.ObjectType.rawValue)),
		])
		etable.add(typeName: typeid.typeName, enumType: typeid)
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
			let result: Bool = value.isDate
			return JSValue(bool: result, in: ctxt)
		}
		ctxt.set(name: "isDate", function: isDateFunc)

		/* isURL */
		let isURLFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			let result: Bool = value.isURL
			return JSValue(bool: result, in: ctxt)
		}
		ctxt.set(name: "isURL", function: isURLFunc)

		/* typeID */
		let typeidFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			return JSValue(int32: Int32(value.type.rawValue), in: ctxt)
		}
		ctxt.set(name: "typeID", function: typeidFunc)

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

		/* asin */
		let asinFunc: @convention(block) (_ val: JSValue) -> JSValue = {
			(_ val: JSValue) -> JSValue in
			if val.isNumber {
				let x = val.toDouble()
				if -1.0 <= x && x <= 1.0 {
					let result = asin(x)
					return JSValue(double: result, in: ctxt)
				}
			}
			cons.error(string: "Invalid parameter for asin function\n")
			return JSValue(undefinedIn: ctxt)
		}
		ctxt.set(name: "asin", function: asinFunc)

		/* acos */
		let acosFunc: @convention(block) (_ val: JSValue) -> JSValue = {
			(_ val: JSValue) -> JSValue in
			if val.isNumber {
				let x = val.toDouble()
				if -1.0 <= x && x <= 1.0 {
					let result = acos(x)
					return JSValue(double: result, in: ctxt)
				}
			}
			cons.error(string: "Invalid parameter for acos function\n")
			return JSValue(undefinedIn: ctxt)
		}
		ctxt.set(name: "acos", function: acosFunc)

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

		/* sqrt */
		let sqrtFunc: @convention(block) (_ val: JSValue) -> JSValue = {
			(_ val: JSValue) -> JSValue in
			if val.isNumber {
				let dval   = val.toDouble()
				let result = dval.squareRoot()
				return JSValue(double: result, in: ctxt)
			}
			return JSValue(undefinedIn: ctxt)
		}
		ctxt.set(name: "sqrt", function: sqrtFunc)

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
				NSLog("Invalid parameter")
				result = -1
			}
			return JSValue(int32: result, in: ctxt)
		}
		ctxt.set(name: "_select_exit_code", function: selExitFunc)

		/* history */
		let historyFunc: @convention(block) () -> JSValue = {
			() -> JSValue in
			let history = CNCommandHistory.shared.history
			return JSValue(object: history, in: ctxt)
		}
		ctxt.set(name: "commandHistory", function: historyFunc)
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

		/* Rect */
		let rectFunc: @convention(block) (_ xval: JSValue, _ yval: JSValue, _ widthval: JSValue, _ heightval: JSValue) -> JSValue = {
			(_ xval: JSValue, _ yval: JSValue, _ widthval: JSValue, _ heightval: JSValue) -> JSValue in
			if xval.isNumber && yval.isNumber && widthval.isNumber && heightval.isNumber {
				let x	   = xval.toDouble()
				let y	   = yval.toDouble()
				let width  = widthval.toDouble()
				let height = heightval.toDouble()
				let rect   = CGRect(x: x, y: y, width: width, height: height)
				return JSValue(rect: rect, in: ctxt)
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
					 input:   	cons.inputHandle,
					 output:  	cons.outputHandle,
					 error:   	cons.errorHandle)
		ctxt.set(name: "FileManager", object: file)

		let stdin = KLFile(file: CNTextFile(fileHandle: cons.inputHandle), context: ctxt)
		ctxt.set(name: "stdin", object: stdin)

		let stdout = KLFile(file: CNTextFile(fileHandle: cons.outputHandle), context: ctxt)
		ctxt.set(name: "stdout", object: stdout)

		let stderr = KLFile(file: CNTextFile(fileHandle: cons.errorHandle), context: ctxt)
		ctxt.set(name: "stderr", object: stderr)

		/* Curses */
		let curses = KLCurses(console: cons, terminalInfo: terminfo, context: ctxt)
		ctxt.set(name: "Curses", object: curses)

		/* FontManager */
		let fontmgr = KLFontManager(context: ctxt)
		ctxt.set(name: "FontManager", object: fontmgr)

		/* JSON */
		let json = KLJSON(context: ctxt)
		ctxt.set(name: "JSON", object: json)

		/* Char */
		let charobj = KLChar(context: ctxt)
		ctxt.set(name: "Char", object: charobj)

		/* EscapeCode */
		let ecode = KLEscapeCode(context: ctxt)
		ctxt.set(name: "EscapeCode", object: ecode)

		/* Environment */
		let env = KLEnvironment(environment: env, context: ctxt)
		ctxt.set(name: "Environment", object: env)

		/* Built-in script manager */
		let scrmgr = KLBuiltinScriptManager(context: ctxt)
		ctxt.set(name: "ScriptManager", object: scrmgr)
	}

	private func defineGlobalObjects(context ctxt: KEContext, console cons: CNFileConsole, config conf: KEConfig) {
		/* console */
		let newcons = KLConsole(context: ctxt, console: cons)
		ctxt.set(name: "console", object: newcons)
	}

	private func defineConstructors(context ctxt: KEContext, console cons: CNConsole, config conf: KEConfig) {
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
	}

	private func importBuiltinLibrary(context ctxt: KEContext, console cons: CNConsole, config conf: KEConfig)
	{
		let libnames = ["Cancel", "Debug", "Math", "Graphics"]
		do {
			for libname in libnames {
				if let url = CNFilePath.URLForResourceFile(fileName: libname, fileExtension: "js", forClass: KLCompiler.self) {
					let script = try String(contentsOf: url, encoding: .utf8)
					let _ = compile(context: ctxt, statement: script, console: cons, config: conf)
				} else {
					NSLog("Failed to read built-in script")
				}
			}
		} catch {
			NSLog("Failed to read built-in script")
		}
	}

	private func defineOperationObjects(context ctxt: KEContext, terminalInfo terminfo: CNTerminalInfo, environment env: CNEnvironment, console cons: CNFileConsole, config conf: KEConfig) {
		/* Operaion */
		let opfunc: @convention(block) (_ urlsval: JSValue, _ consval: JSValue) -> JSValue = {
			(_ urlsval: JSValue, _ consval: JSValue) -> JSValue in
			let opconsole = KLCompiler.valueToConsole(consoleValue: consval, context: ctxt, logConsole: cons)
			let opconfig  = KEConfig(applicationType: conf.applicationType,
						 doStrict: conf.doStrict,
						 logLevel: conf.logLevel)
			let op        = KLOperationContext(ownerContext:	ctxt,
							   libraries:		[],
							   input:		cons.inputHandle,
							   output:		cons.outputHandle,
							   error:		cons.errorHandle,
							   terminalInfo:	terminfo,
							   environment:		env,
							   config:		opconfig)

			/* User scripts */
			var urls: Array<URL> = []
			if let users = KLCompiler.valueToURLs(URLvalues: urlsval, console: opconsole) {
				urls.append(contentsOf: users)
			}
			/* Compile */
			if op.compile(userStructs: [], userScripts: urls) {
				return JSValue(object: op, in: ctxt)
			} else {
				cons.error(string: "Failed to allocate Operation object\n")
				return JSValue(undefinedIn: ctxt)
			}
		}
		ctxt.set(name: "Operation", function: opfunc)

		/* OperaionQueue */
		let queuefunc: @convention(block) () -> JSValue = {
			() -> JSValue in
			let queue   = KLOperationQueue(context: ctxt, console: ctxt.console)
			return JSValue(object: queue, in: ctxt)
		}
		ctxt.set(name: "OperationQueue", function: queuefunc)
	}

	private func defineThreadFunction(context ctxt: KEContext, processManager procmgr: CNProcessManager, environment env: CNEnvironment, resource res: KEResource, console cons: CNConsole, config conf: KEConfig) {
		/* Thread */
		let thfunc: @convention(block) (_ nameval: JSValue, _ inval: JSValue, _ outval: JSValue, _ errval: JSValue) -> JSValue = {
			(_ nameval: JSValue, _ inval: JSValue, _ outval: JSValue, _ errval: JSValue) -> JSValue in
			if let name    = nameval.toString(),
			   let infile  = KLCompiler.vallueToFileStream(value: inval),
			   let outfile = KLCompiler.vallueToFileStream(value: outval),
			   let errfile = KLCompiler.vallueToFileStream(value: errval),
			   let vm = JSVirtualMachine() {
				let threadobj = KLThreadObject(virtualMachine: vm, scriptFile: .identifier(name), processManager: procmgr, input:  infile, output: outfile, error: errfile, environment: env, resource: res, config: conf)
				let thread    = KLThread(thread: threadobj)
				let _         = procmgr.addProcess(process: threadobj)
				return JSValue(object: thread, in: ctxt)
			} else {
				cons.error(string: "Invalid parameters\n")
			}
			return JSValue(nullIn: ctxt)
		}
		ctxt.set(name: "Thread", function: thfunc)

		/* Run */
		let runfunc: @convention(block) (_ pathval: JSValue, _ inval: JSValue, _ outval: JSValue, _ errval: JSValue) -> JSValue = {
			(_ pathval: JSValue, _ inval: JSValue, _ outval: JSValue, _ errval: JSValue) -> JSValue in
			if let infile  = KLCompiler.vallueToFileStream(value: inval),
			   let outfile = KLCompiler.vallueToFileStream(value: outval),
			   let errfile = KLCompiler.vallueToFileStream(value: errval),
			   let vm = JSVirtualMachine() {
				let file: KLThread.ScriptFile
				if let inurl = self.pathToFullPath(path: pathval, environment: env) {
					file = .url(inurl)
				} else {
					file = .unselected
				}
				let threadobj = KLThreadObject(virtualMachine: vm, scriptFile: file, processManager: procmgr, input:  infile, output: outfile, error: errfile, environment: env, resource: res, config: conf)
				let thread    = KLThread(thread: threadobj)
				let _         = procmgr.addProcess(process: threadobj)
				return JSValue(object: thread, in: ctxt)
			}
			return JSValue(nullIn: ctxt)
		}
		ctxt.set(name: "run", function: runfunc)

		/* _waitUtilExitAll */
		let waitExtFunc: @convention(block) (_ procval: JSValue) -> JSValue = {
			(_ procval: JSValue) -> JSValue in
			if procval.isArray {
				if let procarr = procval.toArray() {
					/* Collect process object */
					var procs: Array<KLProcessProtocol> = []
					for procelm in procarr {
						if let procelm = KLCompiler.anyToProcess(anyValue: procelm) {
							procs.append(procelm)
						} else {
							cons.error(string: "_waitUntilExitAll: Unexpected type parameter")
						}
					}
					/* Wait all processes */
					var ecode: Int32 = 0
					for proc in procs {
						let code = proc.waitUntilExit()
						if code != 0 {
							ecode = code
							break
						}
					}
					return JSValue(int32: ecode, in: ctxt)
				}
			}
			cons.error(string: "_waitUntilExitAll: Unexpected type parameters")
			return JSValue(nullIn: ctxt)
		}
		ctxt.set(name: "_waitUntilExitAll", function: waitExtFunc)
	}

	private func pathToFullPath(path pathval: JSValue, environment env: CNEnvironment) -> URL? {
		let pathstr: String
		if pathval.isURL {
			pathstr = pathval.toURL().path
		} else if pathval.isString {
			pathstr = pathval.toString()
		} else {
			return nil
		}
		if FileManager.default.isAbsolutePath(pathString: pathstr) {
			return URL(fileURLWithPath: pathstr)
		} else {
			let curdir = env.currentDirectory
			return URL(fileURLWithPath: pathstr, relativeTo: curdir)
		}
	}

	private class func valueToConsole(consoleValue consval: JSValue, context ctxt: KEContext, logConsole logcons: CNConsole) -> CNFileConsole {
		let opconsole: CNFileConsole
		if consval.isObject {
			if let consobj = consval.toObject() as? KLConsole {
				opconsole = consobj.console
			} else {
				opconsole = ctxt.console
			}
		} else {
			opconsole = ctxt.console
		}
		return opconsole
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

	private class func vallueToFileStream(value val: JSValue) -> CNFileStream? {
		if let obj = val.toObject() {
			if let file = obj as? KLFile {
				return .fileHandle(file.fileHandle)
			} else if let pipe = obj as? KLPipe {
				return .pipe(pipe.pipe)
			}
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
			}
		}
		return result
	}

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
}

