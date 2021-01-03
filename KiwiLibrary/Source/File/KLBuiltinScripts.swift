/**
 * @file	KLBuiltinScripts.swift
 * @brief	Define KHBuiltScripts class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

@objc public protocol KLBuiltScriptManagerProtocol: JSExport {
	func scriptNames() -> JSValue
	func search(_ name: JSValue) -> JSValue
}

public class KLBuiltinScripts
{
	public class ScriptInfo {
		var url:	URL
		public init(file furl: URL){
			url	= furl
		}
	}

	private var mScriptTable:	Dictionary<String, ScriptInfo>	// script-name, script-info

	public init(){
		mScriptTable = [:]
	}

	public func setup(subdirectory subdir: String?, forClass fclass: AnyClass){
		let newitems = KLBuiltinScripts.readScriptNames(subdirectory: subdir, forClass: fclass)
		for key in newitems.keys {
			mScriptTable[key] = newitems[key]
		}
	}

	public func setup(subdirectory subdir: String?, bundleName bname: String){
		let newitems = KLBuiltinScripts.readScriptNames(subdirectory: subdir, bundleName: bname)
		for key in newitems.keys {
			mScriptTable[key] = newitems[key]
		}
	}

	public func scriptNames() -> Array<String> {
		return Array(mScriptTable.keys)
	}

	public func search(scriptName name: String) -> URL? {
		if let info = mScriptTable[name] {
			return info.url
		}
		return nil
	}

	private class func readScriptNames(subdirectory subdir: String?, forClass fclass: AnyClass) -> Dictionary<String, ScriptInfo> {
		switch CNFilePath.URLsForResourceFiles(fileExtension: "js", subdirectory: subdir, forClass: fclass) {
		case .ok(let urls):
			var result: Dictionary<String, ScriptInfo> = [:]
			for url in urls {
				let name = String(url.lastPathComponent.dropLast(3))	// Remove last ".j"
				let info = ScriptInfo(file: url)
				result[name] = info
			}
			return result
		case .error(let err):
			NSLog("[Internal Error] \(err.description)")
			return [:]
		@unknown default:
			NSLog("[Internal Error] Unknown result")
			return [:]
		}
	}

	private class func readScriptNames(subdirectory subdir: String?, bundleName bname: String) -> Dictionary<String, ScriptInfo> {
		switch CNFilePath.URLsForResourceFiles(fileExtension: "js", subdirectory: subdir, bundleName: bname) {
		case .ok(let urls):
			var result: Dictionary<String, ScriptInfo> = [:]
			for url in urls {
				let name = String(url.lastPathComponent.dropLast(3))	// Remove last ".j"
				let info = ScriptInfo(file: url)
				result[name] = info
			}
			return result
		case .error(let err):
			NSLog("[Internal Error] \(err.description)")
			return [:]
		@unknown default:
			NSLog("[Internal Error] Unknown result")
			return [:]
		}
	}
}

@objc public class KLBuiltinScriptManager: NSObject, KLBuiltScriptManagerProtocol
{
	private var mContext:		KEContext
	private var mBuiltinScript:	KLBuiltinScripts

	public init(context ctxt: KEContext){
		mContext	= ctxt
		mBuiltinScript	= KLBuiltinScripts()
		super.init()
	}

	public func scriptNames() -> JSValue {
		let names = mBuiltinScript.scriptNames()
		return JSValue(object: names, in: mContext)
	}

	public func search(_ name: JSValue) -> JSValue {
		if let namestr = name.toString() {
			if let url = mBuiltinScript.search(scriptName: namestr) {
				let urlobj = KLURL(URL: url, context: mContext)
				return JSValue(object: urlobj, in: mContext)
			}
		}
		return JSValue(nullIn: mContext)
	}
}

