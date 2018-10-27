/**
 * @file	KMProgram.swift
 * @brief	Define KMProgram class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiEngine
import JavaScriptCore
import Foundation

public class KMProgram: KMDefaultObject
{
	public static let EnumTableProperty		= "enumTable"
	public static let SharedObjectsProperty		= "shareObjects"
	public static let ObjectLoaderProperty		= "objectLoader"
	public static let ObjectFactoryProperty		= "objectFactory"
	public static let PrimitiveFactoryProperty	= "primitiveFactory"

	public override init(instanceName iname: String, context ctxt: KEContext) {
		super.init(instanceName: iname, context: ctxt)

		/* Allocate EnumTable */
		let etable = KMDefaultObject(instanceName: KMProgram.EnumTableProperty, context: ctxt)
		self.set(name: KMProgram.EnumTableProperty, object: .Object(etable))
		/* Allocate SharedObject */
		let shared = KMDefaultObject(instanceName: KMProgram.SharedObjectsProperty, context: ctxt)
		self.set(name: KMProgram.SharedObjectsProperty, object: .Object(shared))
		/* Allocate ObjectLoader */
		let loader = KMObjectLoader(instanceName: KMProgram.ObjectLoaderProperty, context: ctxt)
		self.set(name: KMProgram.ObjectLoaderProperty, object: .Object(loader))
		/* Allocate ObjectFactory */
		let objfact = KMObjectFactory(instanceName: KMProgram.ObjectFactoryProperty, context: ctxt)
		self.set(name: KMProgram.ObjectFactoryProperty, object: .Object(objfact))
		/* Allocate PrimitiveFactory */
		let prmfact = KMPrimitiveFactory(instanceName: KMProgram.PrimitiveFactoryProperty, context: ctxt)
		self.set(name: KMProgram.PrimitiveFactoryProperty, object: .Object(prmfact))
	}

	public var enumTable: KMObject? {
		get { return object(name: KMProgram.EnumTableProperty)?.toObject() }
	}

	public var sharedObjects: KMObject? {
		get { return object(name: KMProgram.SharedObjectsProperty)?.toObject() }
	}

	public var objectLoader: KMObjectLoader? {
		get { return object(name: KMProgram.ObjectLoaderProperty)?.toObject() as? KMObjectLoader }
	}

	public var objectFactory: KMObjectFactory? {
		get { return object(name: KMProgram.ObjectFactoryProperty)?.toObject() as? KMObjectFactory }
	}

	public var primitiveFactory: KMPrimitiveFactory? {
		get { return object(name: KMProgram.PrimitiveFactoryProperty)?.toObject() as? KMPrimitiveFactory }
	}
}
