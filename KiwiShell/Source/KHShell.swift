/**
 * @file	KHShell.swift
 * @brief	Define KHShell class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

public class KHShell
{
	public enum EvaluationResult {
		case Continue
		case Exit(code: Int32)
	}

	private var mApplication: 	KEApplication
	private var mResult:		EvaluationResult = .Continue

	public init(application app: KEApplication){
		mApplication = app
		mApplication.context.exceptionCallback = {
			(exception: KEException) in
			let console = self.mApplication.console
			switch exception {
			case .CompileError(let message):
				console.error(string: message + "\n")
			case .Evaluated(_, let result):
				if let value = result {
					let desc = value.description
					console.print(string: desc + "\n")
				}
			case .Runtime(let message):
				console.error(string: message + "\n")
				self.mResult = .Exit(code: -1)
			case .Exit(let code):
				self.mResult = .Exit(code: code)
			case .Terminated(_, let message):
				console.error(string: message + "\n")
				self.mResult = .Exit(code: -1)
			}
		}
	}

	public func execute(commandLine cline: String) -> EvaluationResult {
		mResult = EvaluationResult.Continue
		mApplication.context.runScript(script: cline)
		return mResult
	}
}
