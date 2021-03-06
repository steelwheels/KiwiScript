/**
 * @file	KEManifest.swift
 *  @brief	Define KEManifest class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KEManifestLoader
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

	private func decode(resource res: KEResource, properties data: Dictionary<String, CNNativeValue>) throws {
		/* Decode: "application" */
		if let appval = data[KEResource.ApplicationCategory] {
			if let apppath = appval.toString() {
				res.setApprication(path: apppath)
			} else {
				throw NSError.parseError(message: "application section must have script file name properties")
			}
		}
		/* Decode: "view" */
		if let viewval = data[KEResource.ViewCategory] {
			if let viewpath = viewval.toString() {
				res.setView(path: viewpath)
			} else {
				throw NSError.parseError(message: "view section must have script file name properties")
			}
		}
		/* Decode: "libraries" */
		if let libval = data[KEResource.LibrariesCategory] {
			if let libarr = libval.toArray() {
				let patharr = try decodeFileArray(arrayValue: libarr)
				for path in patharr {
					res.addLibrary(path: path)
				}
			} else {
				throw NSError.parseError(message: "libraries section must have library file name properties")
			}
		}
		/* Decode: "threads" */
		if let scrsval = data[KEResource.ThreadsCategory] {
			if let scrsdict = scrsval.toDictionary() {
				let fmap = try decodeFileMap(properties: scrsdict)
				for (ident, path) in fmap {
					res.setThread(identifier: ident, path: path)
				}
			} else {
				throw NSError.parseError(message: "threads section must have thread script file name properties")
			}
		}
		/* Decode: "subviews" */
		if let sviewsval = data[KEResource.SubViewsCategory] {
			if let sviewsdict = sviewsval.toDictionary() {
				let fmap = try decodeFileMap(properties: sviewsdict)
				for (ident, path) in fmap {
					res.setSubView(identifier: ident, path: path)
				}
			} else {
				throw NSError.parseError(message: "subviews section must have subview script file name properties")
			}
		}
		/* Decode: "data" */
		if let dataval = data[KEResource.DataCategory] {
			if let datadict = dataval.toDictionary() {
				let fmap = try decodeFileMap(properties: datadict)
				for (ident, path) in fmap {
					res.setData(identifier: ident, path: path)
				}
			} else {
				throw NSError.parseError(message: "data section must have data file name properties")
			}
		}
		/* Decode: "images" */
		if let imgval = data[KEResource.ImagesCategory] {
			if let imgdict = imgval.toDictionary() {
				let imap = try decodeFileMap(properties: imgdict)
				for (ident, path) in imap {
					res.setImage(identifier: ident, path: path)
				}
			} else {
				throw NSError.parseError(message: "libraries section must have image file name properties")
			}
		}
	}

	private func decodeFileMap(properties data: Dictionary<String, CNNativeValue>) throws -> Dictionary<String, String> {
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

	private func decodeFileArray(arrayValue data: Array<CNNativeValue>) throws -> Array<String> {
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


