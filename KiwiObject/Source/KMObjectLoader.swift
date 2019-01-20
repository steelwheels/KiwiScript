/**
 * @file	KMObjectLoader.swift
 * @brief	Define KMObjectLoader class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

public class KMObjectLoader: KMDefaultObject
{
	public typealias AllocatorMethod = (_ context: KEContext) -> JSExport

	private var mAllocatorTable:	Dictionary<String, AllocatorMethod>	= [:]

	public func addAllocator(modelName name: String, allocator alloc: @escaping AllocatorMethod) {
		mAllocatorTable[name] = alloc
	}

	public func require(modelName name: String, in owner: AnyClass) -> JSValue? {
		if let val = propertyTable.check(name) {
			return val
		} else {
			if let val = allocate(modelName: name) {
				self.set(name: name, value: val)
				return val
			} else if let val = load(scriptFileName: name, in: owner) {
				self.set(name: name, value: val)
				return val
			}
			return nil
		}
	}

	private func allocate(modelName name: String) -> JSValue? {
		if let method = mAllocatorTable[name] {
			let obj = method(context)
			return JSValue(object: obj, in: context)
		}
		return nil
	}

	private func load(scriptFileName name: String, in owner: AnyClass) -> JSValue? {
		if let url = CNFilePath.URLForResourceFile(fileName: name, fileExtension: "js", subdirectory: "Library", forClass: owner) {
			do {
				let script = try String(contentsOf: url)
				return context.evaluateScript(script)
			} catch _ {
				CNLog(type: .Error, message: "Can not compile for class \"\(name)\"", place: #file)
			}
		} else {
			CNLog(type: .Error, message: "Can not find library] \(name)", place: #function)
		}
		return nil
	}
}


