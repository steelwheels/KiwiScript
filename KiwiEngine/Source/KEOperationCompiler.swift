/**
 * @file	KEOperationCompiler.swift
 * @brief	Define KEOperationCompiler class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KEOperationCompiler: KECompiler
{
	open func compile(context ctxt: KEOperationContext, sourceFiles srcfiles: Array<URL>) -> Bool {
		let context = ctxt.context
		guard super.compile(context: context) else {
			return false
		}

		/* Define global variable: Process */
		let process = ctxt.process
		context.set(name: "Process", object: process)
		super.compile(context: context, instance: "Process", object: process)
		let procstmt = "Process.addListener(\"isCanceled\", function(newval){ if(newval){ _cancel() ; }}) ;\n"
		let _ = super.compile(context: context, statement: procstmt)

		/* Read source files */
		var result = true
		for srcfile in srcfiles {
			let (script, error) = srcfile.loadContents()
			if let scr = script {
				let _ = super.compile(context: context, statement: scr as String)
			} else {
				let desc = message(fromError: error)
				super.error(string: "[Error] \(desc)\n")
				result = false
			}
		}
		return result
	}

	private func message(fromError err: NSError?) -> String {
		if let e = err {
			return e.description
		} else {
			return "Unknown error"
		}
	}
}

