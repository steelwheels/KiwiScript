/**
 * @file	UTManifest.swift
 * @brief	Unit test for KEManifest class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import Foundation
import JavaScriptCore
import KiwiEngine

public func testManifest(console cons: CNConsole, config conf: KEConfig) -> Bool
{
	/*
	guard let bundle = Bundle(path: "UnitTest.bundle") else {
		cons.print(string: "[Error] Can not find bundle\n")
		return false
	}*/

	switch CNFilePath.URLForBundleFile(bundleName: "UnitTest", fileName: "Sample", ofType: "jspkg") {
	case .ok(let url):
		let resource = KEResource(baseURL: url)
		let loader   = KEManifestLoader()
		if let err = loader.load(into: resource) {
			cons.print(string: "[Error] Failed to load manifest: \(err.toString())\n")
			return false
		}

		/* dump */
		cons.print(string: "/* Dump resource */\n")
		resource.toText().print(console: cons, terminal: "")
	case .error(let err):
		cons.print(string: "[Error] \(err.toString())\n")
		return false
	}

	/*
		bundle.bundleURL.appendingPathComponent("Contents/Resources/Library")
	cons.print(string: "URL = \(url.absoluteString)\n")



*/

	return true
}


