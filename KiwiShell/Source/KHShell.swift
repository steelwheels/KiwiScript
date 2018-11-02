/**
 * @file	KHShell.swift
 * @brief	Define KHShell class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiEngine
import KiwiLibrary
import CoconutData
import JavaScriptCore
import Foundation

public class KHShell
{
	public enum EvaluationResult {
		case Continue
		case Exit(code: Int32)
	}

	private var mContext:		KEContext
	private var mConsole:		CNConsole
	private var mResult:		EvaluationResult = .Continue

	public init(context ctxt: KEContext, console cons: CNConsole){
		mContext = ctxt
		mConsole = cons
		ctxt.exceptionCallback = {
			(exception: KEException) in
			let console = self.mConsole
			console.error(string: "[Exception] " + exception.description + "\n")
		}
	}

	public func execute(commandLine cline: String) -> EvaluationResult {
		mResult = EvaluationResult.Continue
		mContext.evaluateScript(cline)
		return mResult
	}
}
