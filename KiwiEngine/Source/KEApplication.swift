/**
 * @file	KEApplication.swift
 * @brief	Define KEApplication class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import CoconutData
import JavaScriptCore
import Foundation

public class KEApplication: KEDefaultObject
{
	public static let ArgumentsProperty	= "arguments"
	public static let ConfigProperty 	= "config"
	public static let ProgramProperty	= "program"

	public var console:	CNConsole

	public convenience init(){
		guard let vm = JSVirtualMachine() else {
			fatalError("Failed to allocate JavaScript VM")
		}
		let ctxt = KEContext(virtualMachine: vm)
		self.init(instanceName: "application", context: ctxt)
	}

	public override init(instanceName iname: String, context ctxt: KEContext) {
		console = CNFileConsole()
		super.init(instanceName: iname, context: ctxt)

		/* Arguments */
		self.set(name: KEApplication.ArgumentsProperty, arrayValue: CommandLine.arguments)
		/* Add config */
		let config = KEConfig(instanceName: KEApplication.ConfigProperty, context: ctxt)
		self.set(name: KEApplication.ConfigProperty, object: config)
		/* Add program */
		let program = KEProgram(instanceName: KEApplication.ProgramProperty, context: ctxt)
		self.set(name: KEApplication.ProgramProperty, object: program)
	}

	public var arguments: Array<Any>? {
		get { return self.getArray(name: KEApplication.ArgumentsProperty) }
	}

	public var config: KEConfig? {
		get { return self.object(name: KEApplication.ConfigProperty) as? KEConfig }
	}

	public var program: KEProgram? {
		get { return self.object(name: KEApplication.ProgramProperty) as? KEProgram }
	}
}

