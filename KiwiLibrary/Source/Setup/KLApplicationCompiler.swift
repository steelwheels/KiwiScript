/**
 * @file	KLSetup.swift
 * @brief	Define KLSetupLibrary function
 * @par Copyright
 *   Copyright (C) 2017-2018 Steel Wheels Project
 */

import KiwiEngine
import KiwiObject
import JavaScriptCore
import CoconutData
import Foundation

public class KLApplicationCompiler: KLProcessCompiler
{
	public init(application app: KMApplication) {
		super.init(process: app)
	}

	public var application: KMApplication {
		get {
			if let app = process as? KMApplication {
				return app
			} else {
				fatalError("Not KMApplication Objec")
			}
		}
	}

	public override func compile(config conf: KLConfig) {
		super.compile(config: conf)
		applyConfig(config: conf)
		defineFunctions(applicationKind: conf.kind)
	}

	private func applyConfig(config conf: KLConfig){
		log(string: "/* Apply config */\n")
		if let appconf = application.config {
			appconf.doVerbose     = conf.doVerbose
			appconf.useStrictMode = conf.doStrict
			appconf.scriptFiles   = conf.scriptFiles
		} else {
			process.console.error(string: "No config object")
		}
	}

	private func defineFunctions(applicationKind kind: KMConfig.ApplicationKind)
	{
		/* exit */
		let exitFunc: @convention(block) (_ value: JSValue) -> JSValue = {
			(_ value: JSValue) -> JSValue in
			let _ = self.application.exit(value)
			return JSValue(undefinedIn: self.process.context)
		}
		defineGlobalFunction(name: "exit", function: exitFunc)
	}
}



