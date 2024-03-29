/**
 * @file	KEResource.swift
 * @brief	Define KEResource class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import CoconutData
import Foundation

open class KEResource: CNResource
{
	public static let ApplicationCategory		= "application"
	public static let ViewCategory			= "view"
	public static let LibrariesCategory		= "libraries"
	public static let ThreadsCategory		= "threads"
	public static let SubViewsCategory		= "subviews"
	public static let DefinitionsCategory		= "definitions"
	public static let StoragesCategory		= "storages"
	public static let ImagesCategory		= "images"

	public static let DefaultIdentifier		= "_default"

	public typealias LoaderFunc	= CNResource.LoaderFunc

	public enum AllocationResult {
		case ok(KEResource)
		case error(NSError)
	}

	private var mFileLoader:		LoaderFunc
	private var mStorageLoader:		LoaderFunc
	private var mImageLoader:		LoaderFunc
	private var mEmptyReset:		ResetFunc
	private var mStorageTable:		Dictionary<String, CNStorage>

	public var fileLoader: LoaderFunc	{ get { return mFileLoader }}

	public override init(packageDirectory packdir: URL){
		mFileLoader = {
			(_ fileurl: URL) -> Any? in
			do {
				return try String(contentsOf: fileurl)
			} catch {
				return nil
			}
		}

		/* Assigne dummy loader (overwritten later) */
		mStorageLoader = { (_ fileurl: URL) -> Any? in return nil }

		mImageLoader = {
			(_ fileurl: URL) -> Any? in
			#if os(OSX)
				return CNImage(contentsOf: fileurl)
			#else
				return CNImage(contentsOfFile: fileurl.path)
			#endif
		}

		mEmptyReset = {
			(_ fileurl: URL, _ contents: Any) -> Bool in return false
		}

		mStorageTable = [:]
		super.init(packageDirectory: packdir)

		/* Update loader */
		mStorageLoader = {
			(_ fileurl: URL) -> Any? in
			return self.getStorage(packageDirectory: packdir, fileURL: fileurl)
		}

		/* Setup categories */
		addCategory(category: KEResource.ApplicationCategory,	loader: mFileLoader, reset: mEmptyReset)
		addCategory(category: KEResource.ViewCategory, 		loader: mFileLoader, reset: mEmptyReset)
		addCategory(category: KEResource.LibrariesCategory,	loader: mFileLoader, reset: mEmptyReset)
		addCategory(category: KEResource.ThreadsCategory,	loader: mFileLoader, reset: mEmptyReset)
		addCategory(category: KEResource.SubViewsCategory,	loader: mFileLoader, reset: mEmptyReset)
		addCategory(category: KEResource.DefinitionsCategory,	loader: mFileLoader, reset: mEmptyReset)
		addCategory(category: KEResource.StoragesCategory,	loader: mStorageLoader, reset: mEmptyReset)
		addCategory(category: KEResource.ImagesCategory, 	loader: mImageLoader, reset: mEmptyReset)
	}

	public convenience init(singleFileURL url: URL) {
		let base = url.deletingLastPathComponent()
		let file = url.lastPathComponent
		self.init(packageDirectory: base)
		setApprication(path: file)
	}

	static public func allocateResource(from url: URL) -> AllocationResult {
		let result: AllocationResult
		let path = NSString(string: url.absoluteString)
		switch path.pathExtension {
		case "jspkg":
			let resource = KEResource(packageDirectory: url)
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

	private func getStorage(packageDirectory packdir: URL, fileURL fileurl: URL) -> CNStorage? {
		let filepath: String
		if let relpath = CNFilePath.relativePathUnderBaseURL(fullPath: fileurl, basePath: packdir){
			filepath = relpath
		} else {
			CNLog(logLevel: .error, message: "Failed to get file path: \(fileurl.path)", atFunction: #function, inFile: #file)
			filepath = "error.json"
		}
		if let vstorage = mStorageTable[filepath] {
			return vstorage
		} else {
			let newstorage = KEResource.allocateStorage(packageDirectory: packdir, filePath: filepath)
			mStorageTable[filepath] = newstorage
			return newstorage
		}
	}

	static public func allocateStorage(packageDirectory packdir: URL, filePath fpath: String) -> CNStorage? {
		/* Put the copy of source file into ApplicationSupport directory */
		let packname = packdir.lastPathComponent
		let dstdir   = CNFilePath.URLforApplicationSupportDirectory(subDirectory: packname)

		let storage = CNStorage(sourceDirectory: packdir, cacheDirectory: dstdir, filePath: fpath)
		switch storage.load() {
		case .success(_):
			break
		case .failure(let err):
			CNLog(logLevel: .error, message: "[Error:sub] \(err.toString())", atFunction: #function, inFile: #file)
			return nil
		}
		return storage
	}

	public func addCategory(category cname: String, loader ldr: @escaping LoaderFunc, reset rst: @escaping ResetFunc) {
		super.allocate(category: cname, loader: ldr, reset: rst)
	}

	/*
	 * application section
	 */
	public func setApprication(path pathstr: String){
		super.set(category: KEResource.ApplicationCategory, identifier: KEResource.DefaultIdentifier, path: pathstr)
	}

	public func pathStringOfApplication() -> String? {
		return super.pathString(category: KEResource.ApplicationCategory, identifier: KEResource.DefaultIdentifier, index: 0)
	}

	public func URLOfApplication() -> URL? {
		if let url = super.fullPathURL(category: KEResource.ApplicationCategory, identifier: KEResource.DefaultIdentifier, index: 0) {
			return url
		} else {
			return nil
		}
	}

	public func loadApplication() -> String? {
		if let script:String = super.load(category: KEResource.ApplicationCategory, identifier: KEResource.DefaultIdentifier, index: 0) {
			return script
		} else {
			return nil
		}
	}

	public func storeApplication(script scr: String) {
		super.store(category: KEResource.ApplicationCategory, identifier: KEResource.DefaultIdentifier, index: 0, content: scr)
	}

	/*
	 * view
	 */
	public func setView(path pathstr: String){
		super.set(category: KEResource.ViewCategory, identifier: KEResource.DefaultIdentifier, path: pathstr)
	}

	public func pathStringOfView() -> String? {
		return super.pathString(category: KEResource.ViewCategory, identifier: KEResource.DefaultIdentifier, index: 0)
	}

	public func URLOfView() -> URL? {
		if let url = super.fullPathURL(category: KEResource.ViewCategory, identifier: KEResource.DefaultIdentifier, index: 0) {
			return url
		} else {
			return nil
		}
	}

	public func loadView() -> String? {
		if let script:String = super.load(category: KEResource.ViewCategory, identifier: KEResource.DefaultIdentifier, index: 0) {
			return script
		} else {
			return nil
		}
	}

	/*
	 * library section
	 */
	public func addLibrary(path pathstr: String){
		super.add(category: KEResource.LibrariesCategory, identifier: KEResource.DefaultIdentifier, path: pathstr)
	}

	public func countOfLibraries() -> Int? {
		return super.count(category: KEResource.LibrariesCategory, identifier: KEResource.DefaultIdentifier)
	}

	public func pathStringOfLibrary(index idx: Int) -> String? {
		return super.pathString(category: KEResource.LibrariesCategory, identifier: KEResource.DefaultIdentifier, index: idx)
	}

	public func URLOfLibrary(index idx: Int) -> URL? {
		if let url = super.fullPathURL(category: KEResource.LibrariesCategory, identifier: KEResource.DefaultIdentifier, index: idx) {
			return url
		} else {
			return nil
		}
	}

	public func loadLibrary(index idx: Int) -> String? {
		if let script:String = super.load(category: KEResource.LibrariesCategory, identifier: KEResource.DefaultIdentifier, index: idx) {
			return script
		} else {
			return nil
		}
	}

	/*
	 * threads
	 */
	public func identifiersOfThread() -> Array<String>? {
		return super.identifiers(category: KEResource.ThreadsCategory)
	}

	public func setThread(identifier ident: String, path pathstr: String){
		super.set(category: KEResource.ThreadsCategory, identifier: ident, path: pathstr)
	}

	public func pathStringOfThread(identifier ident: String) -> String? {
		return super.pathString(category: KEResource.ThreadsCategory, identifier: ident, index: 0)
	}

	public func URLOfThread(identifier ident: String) -> URL? {
		if let url = super.fullPathURL(category: KEResource.ThreadsCategory, identifier: ident, index: 0) {
			return url
		} else {
			return nil
		}
	}

	public func loadThread(identifier ident: String) -> String? {
		if let script:String = super.load(category: KEResource.ThreadsCategory, identifier: ident, index: 0) {
			return script
		} else {
			return nil
		}
	}

	/*
	 * subviews
	 */
	public func identifiersOfSubView() -> Array<String>? {
		return super.identifiers(category: KEResource.SubViewsCategory)
	}

	public func setSubView(identifier ident: String, path pathstr: String){
		super.set(category: KEResource.SubViewsCategory, identifier: ident, path: pathstr)
	}

	public func pathStringOfSubView(identifier ident: String) -> String? {
		return super.pathString(category: KEResource.SubViewsCategory, identifier: ident, index: 0)
	}

	public func URLOfSubView(identifier ident: String) -> URL? {
		if let url = super.fullPathURL(category: KEResource.SubViewsCategory, identifier: ident, index: 0) {
			return url
		} else {
			return nil
		}
	}

	public func loadSubview(identifier ident: String) -> String? {
		if let script:String = super.load(category: KEResource.SubViewsCategory, identifier: ident, index: 0) {
			return script
		} else {
			return nil
		}
	}

	/*
	 * definition section
	 */
	public func addDefinition(path pathstr: String){
		super.add(category: KEResource.DefinitionsCategory, identifier: KEResource.DefaultIdentifier, path: pathstr)
	}

	public func countOfDefinitions() -> Int? {
		return super.count(category: KEResource.DefinitionsCategory, identifier: KEResource.DefaultIdentifier)
	}

	public func pathStringOfDefinition(index idx: Int) -> String? {
		return super.pathString(category: KEResource.DefinitionsCategory, identifier: KEResource.DefaultIdentifier, index: idx)
	}

	public func URLOfDefinition(index idx: Int) -> URL? {
		if let url = super.fullPathURL(category: KEResource.DefinitionsCategory, identifier: KEResource.DefaultIdentifier, index: idx) {
			return url
		} else {
			return nil
		}
	}

	public func loadDefinition(index idx: Int) -> String? {
		if let script:String = super.load(category: KEResource.DefinitionsCategory, identifier: KEResource.DefaultIdentifier, index: idx) {
			return script
		} else {
			return nil
		}
	}

	/*
	 * storages section
	 */
	public func identifiersOfStorage() -> Array<String>? {
		return super.identifiers(category: KEResource.StoragesCategory)
	}

	public func setStorage(identifier ident: String, path pathstr: String){
		super.set(category: KEResource.StoragesCategory, identifier: ident, path: pathstr)
	}

	public func pathStringOfStorage(identifier ident: String) -> String? {
		return super.pathString(category: KEResource.StoragesCategory, identifier: ident, index: 0)
	}

	public func URLOfStorage(identifier ident: String) -> URL? {
		if let url = super.fullPathURL(category: KEResource.StoragesCategory, identifier: ident, index: 0) {
			return url
		} else {
			return nil
		}
	}

	public func loadStorage(identifier ident: String) -> CNStorage? {
		if let storage: CNStorage = super.load(category: KEResource.StoragesCategory, identifier: ident, index: 0) {
			return storage
		} else {
			return nil
		}
	}

	/*
	 * images section
	 */
	public func identifiersOfImage() -> Array<String>? {
		return super.identifiers(category: KEResource.ImagesCategory)
	}

	public func setImage(identifier ident: String, path pathstr: String){
		super.set(category: KEResource.ImagesCategory, identifier: ident, path: pathstr)
	}

	public func pathStringOfImage(identifier ident: String) -> String? {
		return super.pathString(category: KEResource.ImagesCategory, identifier: ident, index: 0)
	}

	public func URLOfImage(identifier ident: String) -> URL? {
		if let url = super.fullPathURL(category: KEResource.ImagesCategory, identifier: ident, index: 0) {
			return url
		} else {
			return nil
		}
	}

	public func loadImage(identifier ident: String) -> CNImage? {
		if let image: CNImage = super.load(category: KEResource.ImagesCategory, identifier: ident, index: 0) {
			return image
		} else {
			return nil
		}
	}
}
