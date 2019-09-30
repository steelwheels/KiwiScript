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
			let json = try readJSON(from: resource.baseURL)
			if let dict = json.toDictionary() {
				try decode(resource: resource, json: dict)
				return nil
			} else {
				throw NSError.parseError(message: "Not JSON data")
			}
		} catch let err as NSError {
			return err
		} catch {
			return NSError.parseError(message: "Unknow error")
		}
	}

	private func readJSON(from url: URL) throws -> CNNativeValue {
		let fileurl = url.appendingPathComponent("manifest.json")
		let (manvaluep, error) = CNJSONFile.readFile(URL: fileurl)
		if let manval = manvaluep {
			return manval
		} else {
			throw error!
		}
	}

	open func decode(resource res: KEResource, json data: Dictionary<String, CNNativeValue>) throws {
		/* Decode: "libraries" */
		if let libval = data["libraries"] {
			if let libarr = libval.toArray() {
				let patharr = try decodeFileArray(json: libarr)
				for path in patharr {
					res.addLibrary(path: path)
				}
			} else {
				throw NSError.parseError(message: "libraries must has array property")
			}
		}
		/* Decode: "scripts" */
		if let scrsval = data["scripts"] {
			if let scrsdict = scrsval.toDictionary() {
				let fmap = try decodeFilesMap(json: scrsdict)
				for (ident, paths) in fmap {
					for path in paths {
						res.addScript(identifier: ident, path: path)
					}
				}
			} else {
				throw NSError.parseError(message: "windows must has object property")
			}
		}
	}

	public func decodeFileMap(json data: Dictionary<String, CNNativeValue>) throws -> Dictionary<String, String> {
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

	public func decodeFilesMap(json data: Dictionary<String, CNNativeValue>) throws -> Dictionary<String, Array<String>> {
		var result: Dictionary<String, Array<String>> = [:]
		for key in data.keys {
			result[key] = []
			if let val = data[key] {
				if let arr = val.toArray() {
					for elm in arr {
						if let str = elm.toString() {
							result[key]?.append(str)
						} else {
							throw NSError.parseError(message: "Invalid value for \"\(key)\" in manifest file")
						}
					}
				} else {
					throw NSError.parseError(message: "Invalid value for \"\(key)\" in manifest file")
				}
			} else {
				throw NSError.parseError(message: "Can not happen")
			}
		}
		return result
	}

	public func decodeFileArray(json data: Array<CNNativeValue>) throws -> Array<String> {
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


