//
//  ViewController.swift
//  UTRunner
//
//  Created by Tomoo Hamada on 2017/08/16.
//  Copyright © 2017年 Steel Wheels Project. All rights reserved.
//

import KiwiEngine
import KiwiShell
import JavaScriptCore
import Cocoa

class ViewController: NSViewController
{
	private var mContext:	KEContext?	= nil
	private var mShell:	KSShell?	= nil

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		runShell()
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}

	private func runShell() {
		let context = KEContext(virtualMachine: JSVirtualMachine())
		let shell   = KSShell(context: context)
		mContext = context
		mShell   = shell

		/* Set "shell" global variable */
		context.setObject(mShell, forKeyedSubscript: NSString(string: "shell"))

		let script0 = KSLsCommand.callerScript()
		Swift.print("SCRIPT: \(script0)")

		/* Compile the caller value */
		let (_, errors0) = KEEngine.runScript(context: context, script: script0)
		if printErrors(errors: errors0) {
			return
		}

		let script1 = "shell.execute(lsCommand)"
		Swift.print("SCRIPT: \(script1)")
		let (_, errors1) = KEEngine.runScript(context: context, script: script1)
		if printErrors(errors: errors1) {
			return
		}
	}

	private func printErrors(errors errs: Array<String>?) -> Bool {
		if let errors = errs {
			if errors.count > 0 {
				for msg in errors {
					Swift.print("[Error] \(msg)")
				}
				return true
			}
		}
		return false
	}
}

