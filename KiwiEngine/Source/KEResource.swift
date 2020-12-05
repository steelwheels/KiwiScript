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
	public static let ImagesCategory		= "images"

	public static let DefaultIdentifier		= "_default"

	public typealias LoaderFunc	= CNResource.LoaderFunc

	public enum AllocationResult {
		case ok(KEResource)
		case error(NSError)
	}

	private var mFileLoader:	LoaderFunc
	private var mImageLoader:	LoaderFunc

	public var fileLoader: LoaderFunc	{ get { return mFileLoader }}

	public override init(baseURL url: URL){
		mFileLoader = {
			(_ url: URL) -> Any? in
			do {
				return try String(contentsOf: url)
			} catch {
				return nil
			}
		}

		mImageLoader = {
			(_ url: URL) -> Any? in
			#if os(OSX)
				return CNImage(contentsOf: url)
			#else
				return CNImage(contentsOfFile: url.path)
			#endif
		}

		super.init(baseURL: url)

		/* Setup categories */
		addCategory(category: KEResource.ApplicationCategory,	loader: mFileLoader)
		addCategory(category: KEResource.ViewCategory, 		loader: mFileLoader)
		addCategory(category: KEResource.LibrariesCategory,	loader: mFileLoader)
		addCategory(category: KEResource.ThreadsCategory,	loader: mFileLoader)
		addCategory(category: KEResource.SubViewsCategory,	loader: mFileLoader)
		addCategory(category: KEResource.ImagesCategory, 	loader: mImageLoader)
	}

	public convenience init(singleFileURL url: URL) {
		let base = url.deletingLastPathComponent()
		let file = url.lastPathComponent
		self.init(baseURL: base)
		setApprication(path: file)
	}

	static public func allocateResource(from url: URL) -> AllocationResult {
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
	static public func allocateBySelectFile() -> AllocationResult {
		let selector = CNFileSelector()
		if let url = selector.selectInputFile(title: "Select script file", extensions: ["js", "jspkg"]) {
			return allocateResource(from: url)
		} else {
			let err = NSError.fileError(message: "File selection is cancelled")
			return .error(err)
		}
	}
	#endif

	public func addCategory(category cname: String, loader ldr: @escaping LoaderFunc) {
		super.allocate(category: cname, loader: ldr)
	}

	public func subset() -> KEResource {
		let newres = KEResource(baseURL: super.baseURL)

		let srccats:Array<String> = [KEResource.LibrariesCategory, KEResource.ThreadsCategory, KEResource.SubViewsCategory]
		for srccat in srccats {
			self.copy(destination: newres, category: srccat)
		}
		return newres
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

	public func storeAppilication(script scr: String) {
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
	 * images section
	 */
	public func identifiersOfImage() -> Array<String>? {
		return super.identifiers(category: KEResource.ImagesCategory)
	}

	public func setImage(identifier ident: String, path pathstr: String){
		super.set(category: KEResource.ImagesCategory, identifier: ident, path: pathstr)
	}

	public func pathStringOfImagae(identifier ident: String) -> String? {
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
