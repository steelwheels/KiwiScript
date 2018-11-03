/**
 * @file	KMProgram.swift
 * @brief	Define KMProgram class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiEngine
import KiwiLibrary
import CoconutData
import JavaScriptCore
import Foundation

public class KMProgram: KMDefaultObject
{
	private var mObjectFactory: 	KMObjectFactory
	private var mObjectLoader:	KMObjectLoader
	private var mPrimitiveFactory:	KMPrimitiveFactory

	public override init(instanceName iname: String, context ctxt: KEContext) {
		mObjectFactory    = KMObjectFactory(instanceName: "objectFactory", context: ctxt)
		mObjectLoader     = KMObjectLoader(instanceName: "objectLoader", context: ctxt)
		mPrimitiveFactory = KMPrimitiveFactory(instanceName: "primitiveFactory", context: ctxt)
		super.init(instanceName: iname, context: ctxt)

		/* Link */
		self.propertyTable.set("objectFactory",    JSValue(object: mObjectFactory.propertyTable,    in: ctxt))
		self.propertyTable.set("objectLoader",     JSValue(object: mObjectLoader.propertyTable,     in: ctxt))
		self.propertyTable.set("primitiveFactory", JSValue(object: mPrimitiveFactory.propertyTable, in: ctxt))
	}

	public var objectFactory:    KMObjectFactory    { get { return mObjectFactory    }}
	public var objectLoader:     KMObjectLoader     { get { return mObjectLoader     }}
	public var primitiveFactory: KMPrimitiveFactory { get { return mPrimitiveFactory }}
}

