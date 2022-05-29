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
		switch readNativeValue(from: resource.packageDirectory) {
		case .success(let nvalue):
			if let dict = nvalue.toDictionary() {
				return decode(resource: resource, properties: dict)
			} else {
				return NSError.parseError(message: "Not manifest data")
			}
		case .failure(let err):
			return err
		}
	}

	private func readNativeValue(from url: URL) -> Result<CNValue, NSError> {
		let fileurl = url.appendingPathComponent("manifest.json")
		if let content = fileurl.loadContents() {
			let parser = CNValueParser()
			switch parser.parse(source: content as String) {
			case .success(let value):
				return .success(value)
			case .failure(let err):
				return .failure(err)
			}
		} else {
			return .failure(NSError.parseError(message: "Failed to load manifest file"))
		}
	}

	private func decode(resource res: KEResource, properties data: Dictionary<String, CNValue>) -> NSError? {
		/* Decode: "application" */
		if let appval = data[KEResource.ApplicationCategory] {
			if let apppath = appval.toString() {
				res.setApprication(path: apppath)
			} else {
				return NSError.parseError(message: "application section must have script file name properties")
			}
		}
		/* Decode: "view" */
		if let viewval = data[KEResource.ViewCategory] {
			if let viewpath = viewval.toString() {
				res.setView(path: viewpath)
			} else {
				return NSError.parseError(message: "view section must have script file name properties")
			}
		}
		/* Decode: "libraries" */
		if let libval = data[KEResource.LibrariesCategory] {
			if let libarr = libval.toArray() {
				switch decodeFileArray(arrayValue: libarr) {
				case .success(let patharr):
					for path in patharr {
						res.addLibrary(path: path)
					}
				case .failure(let err):
					return err
				}
			} else {
				return NSError.parseError(message: "libraries section must have library file name properties")
			}
		}
		/* Decode: "threads" */
		if let scrsval = data[KEResource.ThreadsCategory] {
			if let scrsdict = scrsval.toDictionary() {
				switch decodeFileMap(properties: scrsdict) {
				case .success(let fmap):
					for (ident, path) in fmap {
						res.setThread(identifier: ident, path: path)
					}
				case .failure(let err):
					return err
				}
			} else {
				return NSError.parseError(message: "threads section must have thread script file name properties")
			}
		}
		/* Decode: "subviews" */
		if let sviewsval = data[KEResource.SubViewsCategory] {
			if let sviewsdict = sviewsval.toDictionary() {
				switch decodeFileMap(properties: sviewsdict) {
				case .success(let fmap):
					for (ident, path) in fmap {
						res.setSubView(identifier: ident, path: path)
					}
				case .failure(let err):
					return err
				}
			} else {
				return NSError.parseError(message: "subviews section must have subview script file name properties")
			}
		}
		/* Decode: "definitions" */
		if let defval = data[KEResource.DefinitionsCategory] {
			if let defarr = defval.toArray() {
				switch decodeFileArray(arrayValue: defarr) {
				case .success(let patharr):
					for path in patharr {
						res.addDefinition(path: path)
					}
				case .failure(let err):
					return err
				}
			} else {
				return NSError.parseError(message: "definitions section must have array of file names")
			}
		}
		/* Decode: "storages" */
		if let storageval = data[KEResource.StoragesCategory] {
			if let storagedict = storageval.toDictionary() {
				switch decodeFileMap(properties: storagedict) {
				case .success(let smap):
					for (ident, path) in smap {
						res.setStorage(identifier: ident, path: path)
					}
				case .failure(let err):
					return err
				}
			} else {
				return NSError.parseError(message: "storages section must have value storage name properties")
			}
		}
		/* Decode: "images" */
		if let imgval = data[KEResource.ImagesCategory] {
			if let imgdict = imgval.toDictionary() {
				switch decodeFileMap(properties: imgdict) {
				case .success(let imap):
					for (ident, path) in imap {
						res.setImage(identifier: ident, path: path)
					}
				case .failure(let err):
					return err
				}
			} else {
				return NSError.parseError(message: "images section must have image file name properties")
			}
		}
		return nil // no error
	}

	private func decodeFileMap(properties data: Dictionary<String, CNValue>) -> Result<Dictionary<String, String>, NSError> {
		var result: Dictionary<String, String> = [:]
		for key in data.keys {
			if let val = data[key] {
				if let str = val.toString() {
					result[key] = str
				} else {
					return .failure(NSError.parseError(message: "Invalid value for \"\(key)\" in manifest file"))
				}
			} else {
				return .failure(NSError.parseError(message: "Can not happen"))
			}
		}
		return .success(result)
	}

	private func decodeFileArray(arrayValue data: Array<CNValue>) -> Result<Array<String>, NSError> {
		var result: Array<String> = []
		for elm in data {
			if let path = elm.toString() {
				result.append(path)
			} else {
				return .failure(NSError.parseError(message: "Library file path string is required"))
			}
		}
		return .success(result)
	}
}


