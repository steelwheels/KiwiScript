/**
 * @file	KEObjectManager.swift
 * @brief	Define KEObjectManager class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import CoconutData
import JavaScriptCore
import Foundation

public class KEObjectManager: KEDefaultObject
{
	public typealias AllocatorMethod = (_ context: KEContext) -> JSExport

	private var mAllocatorTable:	Dictionary<String, AllocatorMethod>	= [:]

	public func addAllocator(className name: String, allocator alloc: @escaping AllocatorMethod) {
		mAllocatorTable[name] = alloc
	}

	public func require(className name: String) -> JSValue? {
		if let val = propertyTable.check(name) {
			return val
		} else {
			if let val = allocate(className: name) {
				self.set(name: name, value: val)
				return val
			} else if let val = load(scriptFileName: name) {
				self.set(name: name, value: val)
				return val
			}
			return nil
		}
	}

	private func allocate(className name: String) -> JSValue? {
		if let method = mAllocatorTable[name] {
			let obj = method(context)
			return JSValue(object: obj, in: context)
		}
		return nil
	}

	private func load(scriptFileName name: String) -> JSValue? {
		if let url = CNFilePath.URLForResourceFile(fileName: name, fileExtension: "js", subdirectory: "Library") {
			do {
				let script = try String(contentsOf: url)
				return context.evaluateScript(script)
			} catch _ {
				raiseException(message: "Can not compile for class \"\(name)\"")
			}
		}
		return nil
	}

	private func raiseException(message msg: String) {
		let callback  = context.exceptionCallback
		let exception = KEException.Terminated(context, msg)
		callback(exception)
	}
}


