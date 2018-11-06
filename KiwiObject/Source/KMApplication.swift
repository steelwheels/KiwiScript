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

open class KMApplication: KMDefaultObject
{
	private static let ArgumentsProperty	= "arguments"
	private static let ExitProperty		= "exit"

	private var mProgram: KMProgram?

	public init(instanceName iname: String, context ctxt: KEContext, config cfg: KLConfig) {
		/* Allocate program */
		mProgram = KMProgram(instanceName: "program", context: ctxt)
		/* Init super object */
		super.init(instanceName: iname, context: ctxt)


		/* Add arguments */
		let empty: Array<String> = []
		self.arguments = empty
	}

	public var arguments: Array<Any>? {
		get { return self.getArray(name: KMApplication.ArgumentsProperty) }
		set(args) { if let a = args { self.set(name: KMApplication.ArgumentsProperty, arrayValue: a) }}
	}

	public var program: KMProgram? {
		get {
			return mProgram
		}
		set(prog){
			mProgram = prog
			/* Link: Application -> Program */
			if let p = prog {
				self.propertyTable.set("program", JSValue(object: p.propertyTable, in: context))
			} else {
				self.propertyTable.set("program", JSValue(nullIn: context))
			}
		}
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

