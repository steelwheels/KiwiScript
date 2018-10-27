/**
 * @file	KMApplication.swift
 * @brief	Define KMApplication class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

public protocol KMApplicationProtocol
{
	func exit(_ code: JSValue) -> JSValue
}

public class KMApplication: KMProcess, KMApplicationProtocol
{
	public static let ArgumentsProperty	= "arguments"

	public convenience init(kind knd: KMConfig.ApplicationKind){
		guard let vm = JSVirtualMachine() else {
			fatalError("Failed to allocate JavaScript VM")
		}
		let ctxt = KEContext(virtualMachine: vm)
		self.init(kind: knd, instanceName: "application", context: ctxt)
	}

	public override init(kind knd: KMConfig.ApplicationKind, instanceName iname: String, context ctxt: KEContext) {
		super.init(kind: knd, instanceName: iname, context: ctxt)

		/* Add arguments */
		let empty: Array<String> = []
		self.arguments = empty
	}

	public var arguments: Array<Any>? {
		get { return self.getArray(name: KMApplication.ArgumentsProperty) }
		set(args) { if let a = args { self.set(name: KMApplication.ArgumentsProperty, arrayValue: a) }}
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
					let except = KEException.Runtime("exit is NOT supported")
					context.exceptionCallback(except)
				#endif
			}
		} else {
			let except = KEException.Runtime("No config object")
			context.exceptionCallback(except)
			Darwin.exit(code)
		}
	}
}

