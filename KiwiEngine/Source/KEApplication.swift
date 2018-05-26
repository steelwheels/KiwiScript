/**
 * @file	KEApplication.swift
 * @brief	Define KEApplication class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import JavaScriptCore
import Foundation

public class KEApplication: KEDefaultObject
{
	public init(applicationName aname: String){
		let vm = JSVirtualMachine()
		let context = KEContext(virtualMachine: vm!)
		super.init(instanceName: "application", context: context)
	}

	private func setup(application app: KEApplication){
		/* Allocate "program" object */
		let program = KEDefaultObject(instanceName: "program", context: context)
		app.set(name: "program", object: program)

		/* Allocate "enumTable" object to program object */
		let etable = KEDefaultObject(instanceName: "enumTable", context: context)
		program.set(name: "enumTable", object: etable)
	}
}

