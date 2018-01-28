/**
 * @file	KLModuleManager.swift
 * @brief	Extend KLModuleManager class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import Canary
import KiwiEngine
import JavaScriptCore
import Foundation

public class KLModuleManager
{
	public static var shared: KLModuleManager = KLModuleManager()

	private var mModuleTable:		Dictionary<String, JSExport>
	private var mIs1stExternalModule:	Bool
	private var mContext:			KEContext?
	private var mConsole:			CNCursesConsole?
	private var mTerminateHandler: 		((_ code: Int32) -> Int32)?

	private init(){
		mModuleTable 		= [:]
		mIs1stExternalModule	= true
		mContext     		= nil
		mConsole     		= nil
		mTerminateHandler	= nil
	}

	public func setup(context ctxt: KEContext, console cons: CNCursesConsole, terminateHandler termhdl: @escaping (_ code: Int32) -> Int32){
		mContext 		= ctxt
		mConsole		= cons
		mTerminateHandler	= termhdl
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
		if let ctxt = mContext, let cons = mConsole, let termhdl = mTerminateHandler {
			switch name {
			case "color":	result = KLColor(context: ctxt)
			case "align":	result = KLAlign(context: ctxt)
			case "console":	result = KLConsole(context: ctxt, console: cons)
			case "file":	result = KLFile(context: ctxt)
			case "JSON":	result = KLJSON(context: ctxt)
			case "process":	result = KLProcess(terminateHandler: termhdl)
			default:	result = nil
			}
		} else {
			NSLog("Object is not setupped")
			result = nil
		}
		return result
	}

	public func importExternalModule(moduleName name: String) -> JSValue? {
		let pname = "Library/" + name
		let (url, err) = CNFilePath.URLForBundleFile(bundleName: "jstools", fileName: pname, ofType: "js")
		if let u = url {
			do {
				let script = try String(contentsOf: u)
				return compile(moduleName: name, script: script)
			} catch _ {
				NSLog("[Error] Can not read file: \(name)")
			}
		} else {
			NSLog("[Error] \(err!.toString())")
		}
		return nil
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
		if let ctxt = mContext {
			let (retval, errors) = KEEngine.runScript(context: ctxt, script: script)
			if let errs = errors, let console = mConsole {
				for e in errs {
					console.error(string: "module \"\(name)\": \(e)\n")
				}
				return nil
			} else {
				return retval
			}
		} else {
			NSLog("Internal error")
			return nil
		}
	}
}
