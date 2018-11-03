/**
 * @file	KMApplication.swift
 * @brief	Define KMApplication class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import KiwiEngine
import KiwiLibrary
import CoconutData
import JavaScriptCore
import Foundation

public class KMApplication: KMDefaultObject
{
	private static let ArgumentsProperty	= "arguments"
	private static let ExitProperty		= "exit"

	private var mProgram: KMProgram

	public init(instanceName iname: String, context ctxt: KEContext, config cfg: KLConfig) {
		/* Allocate program */
		mProgram = KMProgram(instanceName: "program", context: ctxt)
		/* Init super object */
		super.init(instanceName: iname, context: ctxt)

		/* Link: Application -> Program */
		self.propertyTable.set("program", JSValue(object: mProgram.propertyTable, in: ctxt))

		/* Add arguments */
		let empty: Array<String> = []
		self.arguments = empty

		/* Set exit method */
		addExitMethod(context: ctxt, config: cfg)
	}

	public var arguments: Array<Any>? {
		get { return self.getArray(name: KMApplication.ArgumentsProperty) }
		set(args) { if let a = args { self.set(name: KMApplication.ArgumentsProperty, arrayValue: a) }}
	}

	private func addExitMethod(context ctxt: KEContext, config cfg: KLConfig){
		let exitFunc: @convention(block) (_ value: JSValue) -> JSValue
		switch cfg.kind {
		case .Terminal:
			exitFunc = {
				(_ value: JSValue) -> JSValue in
				let exitcode = self.valueToCode(value: value)
				return JSValue(int32: exitcode, in: ctxt)
			}
		case .Window:
			exitFunc = {
				(_ value: JSValue) -> JSValue in
				#if os(OSX)
					NSApplication.shared.terminate(self)
				#endif
				return JSValue(undefinedIn: ctxt)
			}
		}
		propertyTable.set(KMApplication.ExitProperty, JSValue(object: exitFunc, in: ctxt))
	}

	private func valueToCode(value val: JSValue) -> Int32 {
		let exitcode: Int32
		if val.isNumber {
			exitcode = val.toInt32()
		} else {
			NSLog("Exit code is NOT integer at #(function)")
			exitcode = 1
		}
		return exitcode
	}
}

