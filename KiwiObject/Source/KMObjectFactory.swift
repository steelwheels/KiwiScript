/**
 * @file	KMObjectFactory.swift
 * @brief	Define KMObjectFactory class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import Foundation

public class KMObjectFactory: KMDefaultObject
{
	public typealias AllocatorMethod = (_ instname: String, _ context: KEContext) -> KMObject

	private var mAllocatorTable:	Dictionary<String, AllocatorMethod>	= [:]

	public var allModelNames: Array<String> {
		get { return Array(mAllocatorTable.keys) }
	}

	public func addAllocator(modelName name: String, allocator alloc: @escaping AllocatorMethod) {
		mAllocatorTable[name] = alloc
	}

	public func allocate(modelName cname: String, instanceName iname: String) -> KMObject? {
		if let method = mAllocatorTable[cname] {
			return method(iname, context)
		}
		return nil
	}
}

