/*
 * @file	main.swift
 * @brief	main function for unit test
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiLibrary
import KiwiEngine
import CoconutData
import Foundation

public func main()
{
	Swift.print("[UnitTest]")

	let application = KEApplication(kind: .Terminal)

	application.console.print(string: "Hello, world!!\n")
	let config = KLConfig(kind: .Terminal, useStrictMode: true, doVerbose: true, scriptFiles: [])

	application.console.print(string: "[Allocate compiler]\n")
	let compiler = KLApplicationCompiler(application: application)

	application.console.print(string: "[Start compile]\n")
	compiler.compile(config: config)

	Swift.print("[Bye]")
}

main()


