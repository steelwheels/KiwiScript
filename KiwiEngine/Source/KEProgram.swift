/**
 * @file	KEProgram.swift
 * @brief	Define KEProgram class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import JavaScriptCore
import Foundation

public class KEProgram: KEDefaultObject
{
	public static let EnumTableProperty		= "enumTable"
	public static let SharedObjectsProperty		= "shareObjects"
	public static let ObjectLoaderProperty		= "objectLoader"
	public static let ObjectFactoryProperty		= "objectFactory"
	public static let PrimitiveFactoryProperty	= "primitiveFactory"

	public override init(instanceName iname: String, context ctxt: KEContext) {
		super.init(instanceName: iname, context: ctxt)

		/* Allocate EnumTable */
		let etable = KEDefaultObject(instanceName: KEProgram.EnumTableProperty, context: ctxt)
		self.set(name: KEProgram.EnumTableProperty, object: .Object(etable))
		/* Allocate SharedObject */
		let shared = KEDefaultObject(instanceName: KEProgram.SharedObjectsProperty, context: ctxt)
		self.set(name: KEProgram.SharedObjectsProperty, object: .Object(shared))
		/* Allocate ObjectLoader */
		let loader = KEObjectLoader(instanceName: KEProgram.ObjectLoaderProperty, context: ctxt)
		self.set(name: KEProgram.ObjectLoaderProperty, object: .Object(loader))
		/* Allocate ObjectFactory */
		let objfact = KEObjectFactory(instanceName: KEProgram.ObjectFactoryProperty, context: ctxt)
		self.set(name: KEProgram.ObjectFactoryProperty, object: .Object(objfact))
		/* Allocate PrimitiveFactory */
		let prmfact = KEPrimitiveFactory(instanceName: KEProgram.PrimitiveFactoryProperty, context: ctxt)
		self.set(name: KEProgram.PrimitiveFactoryProperty, object: .Object(prmfact))
	}

	public var enumTable: KEObject? {
		get { return object(name: KEProgram.EnumTableProperty)?.toObject() }
	}

	public var sharedObjects: KEObject? {
		get { return object(name: KEProgram.SharedObjectsProperty)?.toObject() }
	}

	public var objectLoader: KEObjectLoader? {
		get { return object(name: KEProgram.ObjectLoaderProperty)?.toObject() as? KEObjectLoader }
	}

	public var objectFactory: KEObjectFactory? {
		get { return object(name: KEProgram.ObjectFactoryProperty)?.toObject() as? KEObjectFactory }
	}

	public var primitiveFactory: KEPrimitiveFactory? {
		get { return object(name: KEProgram.PrimitiveFactoryProperty)?.toObject() as? KEPrimitiveFactory }
	}
}
