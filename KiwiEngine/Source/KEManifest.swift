/**
 * @file	KEManifest.swift
 *  @brief	Define KEManifest class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import CoconutData
import Foundation

open class KEManifestLoader
{
	public init() {

	}

	public func load(into resource: KEResource) -> NSError? {
		do {
			let nvalue = try readNativeValue(from: resource.baseURL)
			if let dict = nvalue.toDictionary() {
				try decode(resource: resource, properties: dict)
				return nil
			} else {
				throw NSError.parseError(message: "Not manifest data")
			}
		} catch let err as NSError {
			return err
		} catch {
			return NSError.parseError(message: "Unknow error")
		}
	}

	private func readNativeValue(from url: URL) throws -> CNNativeValue {
		let fileurl = url.appendingPathComponent("manifest.json")
		switch CNNativeValueFile.readFile(URL: fileurl) {
		case .ok(let value):
			return value
		case .error(let err):
			throw err
		@unknown default:
			throw NSError.parseError(message: "Can not happen")
		}
	}

	open func decode(resource res: KEResource, properties data: Dictionary<String, CNNativeValue>) throws {
		/* Decode: "application" */
		if let appval = data["application"] {
			if let apppath = appval.toString() {
				res.setApprication(path: apppath)
			} else {
				throw NSError.parseError(message: "application must has array property")
			}
		}

		/* Decode: "libraries" */
		if let libval = data["libraries"] {
			if let libarr = libval.toArray() {
				let patharr = try decodeFileArray(arrayValue: libarr)
				for path in patharr {
					res.addLibrary(path: path)
				}
			} else {
				throw NSError.parseError(message: "libraries section must has array property")
			}
		}
		/* Decode: "threads" */
		if let scrsval = data["threads"] {
			if let scrsdict = scrsval.toDictionary() {
				let fmap = try decodeFileMap(properties: scrsdict)
				for (ident, path) in fmap {
					res.setThread(identifier: ident, path: path)
				}
			} else {
				throw NSError.parseError(message: "threads section must has object property")
			}
		}
		/* Decode: "views" */
		if let scrsval = data["views"] {
			if let scrsdict = scrsval.toDictionary() {
				let fmap = try decodeFileMap(properties: scrsdict)
				for (ident, path) in fmap {
					res.setView(identifier: ident, path: path)
				}
			} else {
				throw NSError.parseError(message: "views section must has object property")
			}
		}
	}

	public func decodeFileMap(properties data: Dictionary<String, CNNativeValue>) throws -> Dictionary<String, String> {
		var result: Dictionary<String, String> = [:]
		for key in data.keys {
			if let val = data[key] {
				if let str = val.toString() {
					result[key] = str
				} else {
					throw NSError.parseError(message: "Invalid value for \"\(key)\" in manifest file")
				}
			} else {
				throw NSError.parseError(message: "Can not happen")
			}
		}
		return result
	}

	public func decodeFileArray(arrayValue data: Array<CNNativeValue>) throws -> Array<String> {
		var result: Array<String> = []
		for elm in data {
			if let path = elm.toString() {
				result.append(path)
			} else {
				throw NSError.parseError(message: "Library file path string is required")
			}
		}
		return result
	}
}


