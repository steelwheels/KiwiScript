/**
 * @file	KEObjectFactory.swift
 * @brief	Define KEObjectFactory class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KEObjectFactory: KEDefaultObject
{
	public typealias AllocatorMethod = (_ instname: String, _ context: KEContext) -> KEObject

	private var mAllocatorTable:	Dictionary<String, AllocatorMethod>	= [:]

	public var allClassNames: Array<String> {
		get { return Array(mAllocatorTable.keys) }
	}

	public func addAllocator(className name: String, allocator alloc: @escaping AllocatorMethod) {
		mAllocatorTable[name] = alloc
	}

	public func allocate(className cname: String, instanceName iname: String) -> KEObject? {
		if let method = mAllocatorTable[cname] {
			return method(iname, context)
		}
		return nil
	}
}

