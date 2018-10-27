/*
 * @file	KMObjectCompiler.swift
* @brief	Define KMObjectCompiler class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import Foundation

open class KMProcessCompiler: KECompiler
{
	private var mProcess: KMProcess

	public init(process proc: KMProcess){
		mProcess = proc
		super.init(context: proc.context, console: proc.console)
	}

	public var		process: KMProcess { get { return mProcess }}
	open override var	context: KEContext { get { return mProcess.context }}
	public var 		console: CNConsole { get { return mProcess.console }}
	
	public func compile(enumObject eobj: KMObject, enumTable etable: KMObject){
		/* Compile */
		let instname = eobj.instanceName
		log(string: "/* Define Enum: \(instname) */\n")
		context.set(name: instname, object: eobj.propertyTable)
		let members = eobj.propertyTable.propertyNames
		for member in members {
			defineSetter(instance: instname, accessType: .ReadOnlyAccess, propertyName: member)
		}
		/* Store to enum table */
		etable.set(name: instname, object: .Object(eobj))
	}
}
