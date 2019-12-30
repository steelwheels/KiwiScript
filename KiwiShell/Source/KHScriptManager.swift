/**
 * @file	KHSvriptManager.swift
 * @brief	Define KHScriptManager class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import KiwiLibrary
import CoconutData
import Foundation

public class KHScriptManager
{
	public static let shared = KHScriptManager()

	public class ScriptInfo {
		var url:	URL
		public init(file furl: URL){
			url	= furl
		}
	}

	private var mScriptTable:	Dictionary<String, ScriptInfo>	// script-name, script-info

	public init(){
		mScriptTable = KHScriptManager.readScriptNamesInBinaryResource()
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

	private class func readScriptNamesInBinaryResource() -> Dictionary<String, ScriptInfo> {
		switch CNFilePath.URLsForResourceFiles(fileExtension: "js", subdirectory: "Binary", forClass: KHScriptManager.self) {
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
		}
	}

}
