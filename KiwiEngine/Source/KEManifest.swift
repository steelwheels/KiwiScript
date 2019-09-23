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
		/* Decode: "application" */
		if let appval = data["application"] {
			if let appstr = appval.toString() {
				res.addApplicationScriptMap(path: appstr)
			} else {
				throw NSError.parseError(message: "application must has string property")
			}
		}
		/* Decode: "libraries" */
		if let libval = data["libraries"] {
			if let libarr = libval.toArray() {
				let patharr = try decodeFileArray(json: libarr)
				for path in patharr {
					res.addLibraryScriptMap(path: path)
				}
			} else {
				throw NSError.parseError(message: "libraries must has array property")
			}
		}
		/* Decode: "scripts" */
		if let scrsval = data["scripts"] {
			if let scrsdict = scrsval.toDictionary() {
				let fmap = try decodeFileMap(json: scrsdict)
				for (ident, path) in fmap {
					res.addScript(identifier: ident, path: path)
				}
			} else {
				throw NSError.parseError(message: "windows must has object property")
			}
		}
	}

	private func decodeFileMap(json data: Dictionary<String, CNNativeValue>) throws -> Dictionary<String, String> {
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

	private func decodeFileArray(json data: Array<CNNativeValue>) throws -> Array<String> {
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

/*
public class AMCManifest
{

	private static func decode(resource res: AMCResource, json data: Dictionary<String, CNNativeValue>, console cons: CNConsole) throws {

		/* Decode: "engine" */
		if let scrsval = data["engine"] {
			if let scrsarr = scrsval.toArray() {
				let patharr = try decodeFileArray(json: scrsarr)
				for path in patharr {
					res.addEngineScriptMap(path: path)
				}
			} else {
				throw NSError.parseError(message: "libraries must has array property")
			}
		}
		/* Decode: "main_window" */
		if let mwinval = data["main_window"] {
			if let mwinstr = mwinval.toString() {
				res.setMainWindowName(name: mwinstr)
			} else {
				throw NSError.parseError(message: "main_window must has string property")
			}
		}
		/* Decode: "windows" */
		if let winsval = data["windows"] {
			if let winsdict = winsval.toDictionary() {
				let fmap = decodeFileMap(json: winsdict, console: cons)
				for (ident, path) in fmap {
					res.addWindowScript(identifier: ident, path: path)
				}
			} else {
				throw NSError.parseError(message: "windows must has object property")
			}
		}
		/* Decode: "images" */
		if let imgsval = data["images"] {
			if let imgsdict = imgsval.toDictionary() {
				let fmap = decodeFileMap(json: imgsdict, console: cons)
				for (ident, path) in fmap {
					res.setImageFile(identifier: ident, path: path)
				}
			} else {
				throw NSError.parseError(message: "images must has object property")
			}
		}
	}

	private static func decodePreference(json data: Dictionary<String, CNNativeValue>, resource res: AMCResource, console cons: CNConsole) throws {
		if let scrval = data["preference"] {
			if let scrstr = scrval.toString() {
				let prefurl = res.baseURL.appendingPathComponent(scrstr)
				if let err = CNPreference.parsePreference(from: prefurl, console: cons) {
					throw err
				}
			} else {
				throw NSError.parseError(message: "File path is required for preference")
			}
		}
	}
}

*/



