/**
 * @file	KEApplication.swift
 * @brief	Define KEApplication class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import CoconutData
import JavaScriptCore
import Foundation

public protocol KEApplicationProtocol
{
	func exit(_ code: JSValue) -> JSValue
}

public class KEApplication: KEDefaultObject, KEApplicationProtocol
{
	public static let ArgumentsProperty	= "arguments"
	public static let ConfigProperty 	= "config"
	public static let ProgramProperty	= "program"

	public var console:	CNConsole

	public convenience init(kind knd: KEConfig.ApplicationKind){
		guard let vm = JSVirtualMachine() else {
			fatalError("Failed to allocate JavaScript VM")
		}
		let ctxt = KEContext(virtualMachine: vm)
		self.init(kind: knd, instanceName: "application", context: ctxt)
	}

	public init(kind knd: KEConfig.ApplicationKind, instanceName iname: String, context ctxt: KEContext) {
		console = CNFileConsole()
		super.init(instanceName: iname, context: ctxt)

		/* Add config */
		let config = KEConfig(kind: knd, instanceName: KEApplication.ConfigProperty, context: ctxt)
		self.set(name: KEApplication.ConfigProperty, object: .Object(config))
		/* Add program */
		let program = KEProgram(instanceName: KEApplication.ProgramProperty, context: ctxt)
		self.set(name: KEApplication.ProgramProperty, object: .Object(program))
	}

	public var arguments: Array<Any>? {
		get { return self.getArray(name: KEApplication.ArgumentsProperty) }
		set(args) { if let a = args { self.set(name: KEApplication.ArgumentsProperty, arrayValue: a) }}
	}

	public var config: KEConfig? {
		get { return self.object(name: KEApplication.ConfigProperty)?.toObject() as? KEConfig }
	}

	public var program: KEProgram? {
		get { return self.object(name: KEApplication.ProgramProperty)?.toObject() as? KEProgram }
	}

	public func exit(_ error: JSValue) -> JSValue {
		/* Get int32 error code */
		var ecode: Int32 = 0
		if error.isNumber {
			ecode = error.toInt32()
		}
		exit(errorCode: ecode)
		return JSValue(undefinedIn: context)
	}

	public func exit(errorCode code: Int32){
		if let cfg = config {
			switch cfg.kind {
			case .Terminal:
				Darwin.exit(code)
			case .Window:
				#if os(OSX)
					NSApplication.shared.terminate(self)
				#else
					NSLog("exit is NOT supported")
					break
				#endif
			}
		} else {
			NSLog("No Config Object")
			Darwin.exit(code)
		}
	}
}

