/**
 * @file	KMProcess.swift
 * @brief	Define KMProcess class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import Foundation

public class KMProcess: KMDefaultObject
{
	public static let ConfigProperty 	= "config"
	public static let ProgramProperty	= "program"

	public var console:	CNConsole

	public init(kind knd: KMConfig.ApplicationKind, instanceName iname: String, context ctxt: KEContext){
		console = CNFileConsole()
		super.init(instanceName: iname, context: ctxt)

		/* Update exception to use console */
		ctxt.exceptionCallback = {
			(_ result: KEException) -> Void in
			let msg = result.description
			self.console.error(string: "[Exception] \(msg)")
		}

		/* Add config */
		let config = KMConfig(kind: knd, instanceName: KMProcess.ConfigProperty, context: ctxt)
		self.set(name: KMProcess.ConfigProperty, object: .Object(config))

		/* Add program */
		let program = KMProgram(instanceName: KMProcess.ProgramProperty, context: ctxt)
		self.set(name: KMProcess.ProgramProperty, object: .Object(program))
	}

	public var config: KMConfig? {
		get { return self.object(name: KMProcess.ConfigProperty)?.toObject() as? KMConfig }
	}
	
	public var program: KMProgram? {
		get { return self.object(name: KMProcess.ProgramProperty)?.toObject() as? KMProgram }
	}
}

