/**
 * @file	KEProcess.swift
 * @brief	Define KEProcess class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KEProcess: KEDefaultObject
{
	public static let ConfigProperty 	= "config"
	public static let ProgramProperty	= "program"

	public var console:	CNConsole

	public init(kind knd: KEConfig.ApplicationKind, instanceName iname: String, context ctxt: KEContext){
		console = CNFileConsole()
		super.init(instanceName: iname, context: ctxt)

		/* Update exception to use console */
		ctxt.exceptionCallback = {
			(_ result: KEException) -> Void in
			let msg = result.description
			self.console.error(string: "[Exception] \(msg)")
		}

		/* Add config */
		let config = KEConfig(kind: knd, instanceName: KEProcess.ConfigProperty, context: ctxt)
		self.set(name: KEProcess.ConfigProperty, object: .Object(config))

		/* Add program */
		let program = KEProgram(instanceName: KEProcess.ProgramProperty, context: ctxt)
		self.set(name: KEProcess.ProgramProperty, object: .Object(program))
	}

	public var config: KEConfig? {
		get { return self.object(name: KEApplication.ConfigProperty)?.toObject() as? KEConfig }
	}
	
	public var program: KEProgram? {
		get { return self.object(name: KEProcess.ProgramProperty)?.toObject() as? KEProgram }
	}
}

