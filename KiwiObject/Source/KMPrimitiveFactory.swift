/**
 * @file	KMPrimitiveFactory.swift
 * @brief	Define KMPrimitiveFactory class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

public class KMPrimitiveFactory: KMDefaultObject
{
	public typealias AllocatorMethod = (_ value: CNValue, _ context: KEContext) -> JSValue?

	private var mParameterTypeTable:	Dictionary<String, CNValueType> 	= [:]
	private var mAllocatorTable:		Dictionary<String, AllocatorMethod>	= [:]

	public override init(instanceName iname: String, context ctxt: KEContext) {
		super.init(instanceName: iname, context: ctxt)

		/* Add default factory */
		/* bool */
		self.addAllocator(typeName: "bool", parameterType: .BooleanType, allocator: {
			(_ value: CNValue, _ context: KEContext) -> JSValue? in
			if let v = value.booleanValue {
				return JSValue(bool: v, in: context)
			}
			return nil
		})
		/* int */
		self.addAllocator(typeName: "int", parameterType: .IntType, allocator: {
			(_ value: CNValue, _ context: KEContext) -> JSValue? in
			if let v = value.intValue {
				return JSValue(int32: Int32(v), in: context)
			}
			return nil
		})
		/* float */
		self.addAllocator(typeName: "float", parameterType: .FloatType, allocator: {
			(_ value: CNValue, _ context: KEContext) -> JSValue? in
			if let v = value.doubleValue {
				return JSValue(double: v, in: context)
			}
			return nil
		})
		/* string */
		self.addAllocator(typeName: "string", parameterType: .StringType, allocator: {
			(_ value: CNValue, _ context: KEContext) -> JSValue? in
			if let v = value.stringValue {
				return JSValue(object: String(v), in: context)
			}
			return nil
		})
		/* void */
		self.addAllocator(typeName: "void", parameterType: .VoidType, allocator: {
			(_ value: CNValue, _ context: KEContext) -> JSValue? in
			return JSValue(undefinedIn: context)
		})
	}

	public var allTypeNames: Array<String> {
		get { return Array(mAllocatorTable.keys) }
	}

	public func addAllocator(typeName tname: String, parameterType ptype: CNValueType, allocator alloc: @escaping AllocatorMethod) {
		mParameterTypeTable[tname]	= ptype
		mAllocatorTable[tname] 		= alloc
	}

	public func parameterType(typeName tname: String) -> CNValueType? {
		return mParameterTypeTable[tname]
	}

	public func allocate(typeName tname: String, initialValue ival: CNValue) -> JSValue? {
		if let method = mAllocatorTable[tname] {
			return method(ival, context)
		}
		return nil
	}
}
