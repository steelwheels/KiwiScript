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
	public static let EnumTableProperty	= "enumTable"
	public static let SharedObjectsProperty	= "shareObjects"
	public static let ObjectLoaderProperty	= "objectLoader"

	public override init(instanceName iname: String, context ctxt: KEContext) {
		super.init(instanceName: iname, context: ctxt)

		/* Allocate EnumTable */
		let etable = KEDefaultObject(instanceName: KEProgram.EnumTableProperty, context: ctxt)
		self.set(name: KEProgram.EnumTableProperty, object: etable)
		/* Allocate SharedObject */
		let shared = KEDefaultObject(instanceName: KEProgram.SharedObjectsProperty, context: ctxt)
		self.set(name: KEProgram.SharedObjectsProperty, object: shared)
		/* Allocate ObjectLoader */
		let loader = KEObjectLoader(instanceName: KEProgram.ObjectLoaderProperty, context: ctxt)
		self.set(name: KEProgram.ObjectLoaderProperty, object: loader)
	}

	public var enumTable: KEObject? {
		get { return object(name: KEProgram.EnumTableProperty) }
	}

	public var sharedObjects: KEObject? {
		get { return object(name: KEProgram.SharedObjectsProperty) }
	}

	public var objectLoader: KEObjectLoader? {
		get { return object(name: KEProgram.ObjectLoaderProperty) as? KEObjectLoader }
	}
}

