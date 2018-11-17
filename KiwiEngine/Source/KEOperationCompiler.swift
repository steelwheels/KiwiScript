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
	open func compile(context ctxt: KEContext, process proc: KEOperationProcess, sourceFiles srcfiles: Array<URL>) -> Bool {
		guard super.compile(context: ctxt) else {
			return false
		}

		/* Define global variable: Process */
		ctxt.set(name: "Process", object: proc)
		super.compile(context: ctxt, instance: "Process", object: proc)
		let procstmt = "Process.addListener(\"isCanceled\", function(newval){ if(newval){ _cancel() ; }}) ;\n"
		let _ = super.compile(context: ctxt, statement: procstmt)

		/* Read source files */
		var result = true
		for srcfile in srcfiles {
			let (script, error) = srcfile.loadContents()
			if let scr = script {
				let _ = super.compile(context: ctxt, statement: scr as String)
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

