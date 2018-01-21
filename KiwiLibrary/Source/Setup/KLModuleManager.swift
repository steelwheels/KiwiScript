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

	private var mModuleTable:	Dictionary<String, JSExport>
	private var mContext:		KEContext?
	private var mConsole:		CNCursesConsole?
	private var mTerminateHandler: 	((_ code: Int32) -> Int32)?

	private init(){
		mModuleTable 		= [:]
		mContext     		= nil
		mConsole     		= nil
		mTerminateHandler	= nil
	}

	public func setup(context ctxt: KEContext, console cons: CNCursesConsole, terminateHandler termhdl: @escaping (_ code: Int32) -> Int32){
		mContext 		= ctxt
		mConsole		= cons
		mTerminateHandler	= termhdl
	}

	public func getModule(moduleName name: String) -> JSExport? {
		if let obj = mModuleTable[name] {
			/* The object is already exist */
			return obj
		} else {
			/* the object is NOT exist yet */
			if let newobj = allocateModule(moduleName: name) {
				mModuleTable[name] = newobj
				return newobj
			} else {
				return nil
			}
		}
	}

	private func allocateModule(moduleName name: String) -> JSExport? {
		/* allocate matched built-in module */
		if let obj = allocateBuiltinModule(moduleName: name){
			return obj
		}
		return nil
	}

	private func allocateBuiltinModule(moduleName name: String) -> JSExport? {
		let result: JSExport?
		if let ctxt = mContext, let cons = mConsole, let termhdl = mTerminateHandler {
			switch name {
			case "color":	result = KLColor(context: ctxt)
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
}
