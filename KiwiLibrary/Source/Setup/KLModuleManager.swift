/**
 * @file	KLModuleManager.swift
 * @brief	Define KLModuleManager class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

public class KLModuleManager
{
	public static var shared: KLModuleManager = KLModuleManager()

	private var mModuleTable:		Dictionary<String, JSExport>
	private var mIs1stExternalModule:	Bool
	private var mContext:			KEContext?
	private var mArguments:			Array<String>
	private var mConsole:			CNConsole?
	private var mExceptionHandler: 		((_ exception: KEException) -> Void)?

	private init(){
		mModuleTable 		= [:]
		mIs1stExternalModule	= true
		mContext     		= nil
		mArguments		= []
		mConsole     		= nil
		mExceptionHandler	= nil
	}

	public func setup(context ctxt: KEContext, arguments args: Array<String>, console cons: CNConsole, exceptionHandler ehandler: @escaping (_ exception: KEException) -> Void){
		mContext 		= ctxt
		mArguments		= args
		mConsole		= cons
		mExceptionHandler	= ehandler
	}

	public func getBuiltinModule(moduleName name: String) -> JSExport? {
		if let obj = mModuleTable[name] {
			/* The object is already exist */
			return obj
		} else {
			/* the object is NOT exist yet */
			if let newobj = allocateBuiltinModule(moduleName: name) {
				mModuleTable[name] = newobj
				return newobj
			} else {
				return nil
			}
		}
	}

	private func allocateBuiltinModule(moduleName name: String) -> JSExport? {
		let result: JSExport?
		if let ctxt = mContext, let cons = mConsole, let ehandler = mExceptionHandler {
			switch name {
			case "console":		result = KLConsole(context: ctxt, console: cons)
			#if os(OSX)
			case "curses":		result = KLCurses(context: ctxt)
			#endif
			case "file":		result = KLFile(context: ctxt)
			case "pipe":		result = KLPipe(context: ctxt)
			case "JSON":		result = KLJSON(context: ctxt)
			case "contact":		result = KLContact(context: ctxt, console: cons)
			case "process":
				#if os(OSX)
					result = KLProcess(context: ctxt, arguments: mArguments, exceptionHandler: ehandler)
				#else
					result = nil
				#endif
			case "shell":
				#if os(OSX)
					result = KLShell(context: ctxt)
				#else
					result = nil
				#endif
			default:
				result = nil
			}
		} else {
			NSLog("Object is not setupped")
			result = nil
		}
		return result
	}

	public func importExternalModule(moduleName name: String) -> JSValue? {
		var result: JSValue? = nil
		let pname = "Library/" + name
		let (url, err) = CNFilePath.URLForBundleFile(bundleName: "jstools", fileName: pname, ofType: "js")
		if let u = url {
			do {
				let script = try String(contentsOf: u)
				result = compile(moduleName: name, script: script)
			} catch _ {
				let message = "Can not read file: \(name)"
				raiseException(exception: .CompileError(message))
			}
		} else {
			let message: String
			if let e = err {
				message = e.description
			} else {
				message = "Unknown error"
			}
			raiseException(exception: .CompileError(message))
		}
		return result
	}

	private func compile(moduleName name: String, script scr: String) -> JSValue? {
		/* make script */
		let head: String
		if mIs1stExternalModule {
			head = "module = {} ;\n"
			mIs1stExternalModule = false
		} else {
			head = ""
		}
		let script = head + scr + " ; module.exports ;\n"

		/* compile */
		var retval: JSValue? = nil
		if let ctxt = mContext {
			ctxt.runScript(script: script, exceptionHandler: {
				(_ result: KEException) -> Void in
				self.raiseException(exception: result)
				switch result {
				case .Evaluated(_, let value):
					retval = value
				case .CompileError(_), .Exit(_), .Terminated(_, _):
					retval = nil
				}
			})
		} else {
			raiseException(exception: .CompileError("Context is not defined"))
		}
		return retval
	}

	private func raiseException(exception excep: KEException) {
		if let ehandler = mExceptionHandler {
			ehandler(excep)
		} else {
			NSLog(excep.description)
		}
	}
}
