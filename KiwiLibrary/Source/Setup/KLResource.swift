/**
 * @file	KLResource.swift
 * @brief	Define KLResource class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import Foundation

public extension KEResource
{
	enum AllocationResult {
		case ok(KEResource)
		case error(NSError)
	}

	static func allocateResource(from url: URL) -> AllocationResult {
		let result: AllocationResult
		let path = NSString(string: url.absoluteString)
		switch path.pathExtension {
		case "jspkg":
			let resource = KEResource(baseURL: url)
			let loader = KEManifestLoader()
			if let err = loader.load(into: resource) {
				result = .error(err)
			}  else {
				result = .ok(resource)
			}
		default:
			let resource = KEResource(singleFileURL: url)
			result = .ok(resource)
		}
		return result
	}

	#if os(OSX)
	static func allocateBySelectFile() -> AllocationResult {
		let selector = CNFileSelector()
		if let url = selector.selectInputFile(title: "Select script file", extensions: ["js", "jspkg"]) {
			return allocateResource(from: url)
		} else {
			let err = NSError.fileError(message: "File selection is cancelled")
			return .error(err)
		}
	}
	#endif
}
