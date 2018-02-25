/**
 * @file	KHShell.swift
 * @brief	Define KHShell class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiEngine
import Canary
import JavaScriptCore
import Foundation

public class KHShell
{
	private var mContext: KEContext
	private var mConsole: CNConsole

	public init(context ctxt: KEContext, console cons: CNConsole){
		mContext = ctxt
		mConsole = cons
	}

	public enum EvaluationResult {
	case Continue
	case Exit(code: Int32)
	}

	public func execute(commandLine cline: String) -> EvaluationResult {
		var result: EvaluationResult = .Continue
		mContext.runScript(script: cline, exceptionHandler: {
			(exception: KEException) in
			switch exception {
			case .CompileError(let message):
				self.mConsole.error(string: message)
			case .Evaluated(_, let result):
				if let value = result {
					let desc = value.description
					self.mConsole.print(string: desc + "\n")
				}
			case .Exit(let code):
				result = .Exit(code: code)
			case .Terminated(_, let message):
				self.mConsole.error(string: message)
				result = .Exit(code: -1)
			}
		})
		return result
	}
}
